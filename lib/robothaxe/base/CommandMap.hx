/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package robothaxe.base;

import robothaxe.event.Event;
import robothaxe.event.IEventDispatcher;
import robothaxe.util.Dictionary;
import robothaxe.core.ICommandMap;
import robothaxe.core.IInjector;
import robothaxe.core.IReflector;
import robothaxe.util.Register;

/**
 * An abstract <code>ICommandMap</code> implementation
 */
class CommandMap implements ICommandMap
{
	/**
	 * The <code>IEventDispatcher</code> to listen to
	 */
	var eventDispatcher:IEventDispatcher;
	
	/**
	 * The <code>IInjector</code> to inject with
	 */
	var injector:IInjector;
	
	/**
	 * The <code>IReflector</code> to reflect with
	 */
	var reflector:IReflector;
	
	/**
	 * Internal
	 *
	 * TODO: This needs to be documented
	 */
	var eventTypeMap:Dictionary<String, Dictionary<Class<Dynamic>,Dictionary<Class<Dynamic>, Dynamic>>>;
	
	/**
	 * Internal
	 *
	 * Collection of command classes that have been verified to implement an <code>execute</code> method
	 */
	var verifiedCommandClasses:Register<Class<Dynamic>>;
	
	var detainedCommands:Register<Dynamic>;
	
	//---------------------------------------------------------------------
	//  Constructor
	//---------------------------------------------------------------------
	
	/**
	 * Creates a new <code>CommandMap</code> object
	 *
	 * @param eventDispatcher The <code>IEventDispatcher</code> to listen to
	 * @param injector An <code>IInjector</code> to use for this context
	 * @param reflector An <code>IReflector</code> to use for this context
	 */
	public function new(eventDispatcher:IEventDispatcher, injector:IInjector, reflector:IReflector)
	{
		this.eventDispatcher = eventDispatcher;
		this.injector = injector;
		this.reflector = reflector;
		this.eventTypeMap = new Dictionary<String, Dictionary<Class<Dynamic>,Dictionary<Class<Dynamic>, Dynamic>>>();
		this.verifiedCommandClasses = new Register<Class<Dynamic>>();
		this.detainedCommands = new Register<Dynamic>();
	}
	
	//---------------------------------------------------------------------
	//  API
	//---------------------------------------------------------------------
	
	/**
	 * @inheritDoc
	 */
	public function mapEvent(eventType:String, commandClass:Class<Dynamic>, ?eventClass:Class<Dynamic>=null, ?oneshot:Bool=false):Void
	{
		verifyCommandClass(commandClass);

		if (eventClass == null) eventClass = Event;
		
		var eventClassMap = eventTypeMap.get(eventType);
		if (eventClassMap == null)
		{
			eventClassMap = new Dictionary<Class<Dynamic>,Dictionary<Class<Dynamic>, Dynamic>>();
			eventTypeMap.add(eventType, eventClassMap);
		}
			
		var callbacksByCommandClass = eventClassMap.get(eventClass);
		if (callbacksByCommandClass == null)
		{
			callbacksByCommandClass = new Dictionary<Class<Dynamic>, Dynamic>();
			eventClassMap.add(eventClass, callbacksByCommandClass);
		}
			
		if (callbacksByCommandClass.get(commandClass) != null)
		{
			throw new ContextError(ContextError.E_COMMANDMAP_OVR + ' - eventType (' + eventType + ') and Command (' + commandClass + ')');
		}
		
		var me = this;
		var commandCallback = function(event:Event)
		{
			me.routeEventToCommand(event, commandClass, oneshot, eventClass);
		};

		eventDispatcher.addEventListener(eventType, commandCallback, false, 0, true);
		callbacksByCommandClass.add(commandClass, commandCallback);
	}
	
	/**
	 * @inheritDoc
	 */
	public function unmapEvent(eventType:String, commandClass:Class<Dynamic>, ?eventClass:Class<Dynamic> = null):Void
	{
		if (eventClass == null) eventClass = Event;

		var eventClassMap = eventTypeMap.get(eventType);
		if (eventClassMap == null) return;
		
		var callbacksByCommandClass = eventClassMap.get(eventClass);
		if (callbacksByCommandClass == null) return;
		
		var commandCallback = callbacksByCommandClass.get(commandClass);
		if (commandCallback == null) return;
		
		eventDispatcher.removeEventListener(eventType, commandCallback, false);
		callbacksByCommandClass.remove(commandClass);
	}
	
	/**
	 * @inheritDoc
	 */
	public function unmapEvents():Void
	{
		for (eventType in eventTypeMap)
		{
			var eventClassMap = eventTypeMap.get(eventType);
			
			for (eventClass in eventClassMap)
			{
				var callbacksByCommandClass = eventClassMap.get(eventClass);

				for (commandClass in callbacksByCommandClass)
				{
					var commandCallback = callbacksByCommandClass.get(commandClass);
					eventDispatcher.removeEventListener(eventType, commandCallback, false);
				}
			}
		}

		eventTypeMap.empty();
	}
	
	/**
	 * @inheritDoc
	 */
	public function hasEventCommand(eventType:String, commandClass:Class<Dynamic>, ?eventClass:Class<Dynamic>=null):Bool
	{
		if (eventClass == null) eventClass = Event;

		var eventClassMap = eventTypeMap.get(eventType);
		if (eventClassMap == null) return false;
		
		var callbacksByCommandClass = eventClassMap.get(eventClass);
		if (callbacksByCommandClass == null) return false;
		
		return callbacksByCommandClass.get(commandClass) != null;
	}
	
	/**
	 * @inheritDoc
	 */
	public function execute(commandClass:Class<Dynamic>, ?payload:Dynamic=null, ?payloadClass:Class<Dynamic>=null, ?named:String=""):Void
	{
		verifyCommandClass(commandClass);

		if (payload != null || payloadClass != null)
		{
			if (payloadClass == null)
			{
				payloadClass = reflector.getClass(payload);
			}
			
			injector.mapValue(payloadClass, payload, named);
		}
		
		var command:Dynamic = injector.instantiate(commandClass);
		
		if (payload != null || payloadClass != null)
		{
			injector.unmap(payloadClass, named);
		}
		
		command.execute();
	}
	
	/**
	 * @inheritDoc
	 */
	public function detain(command:Dynamic):Void
	{
		detainedCommands.add(command);
	}
	
	/**
	 * @inheritDoc
	 */
	public function release(command:Dynamic):Void
	{
		detainedCommands.remove(command);
	}
	
	/**
	 * @throws robothaxe.base::ContextError 
	 */
	function verifyCommandClass(commandClass:Class<Dynamic>):Void
	{
		if (!verifiedCommandClasses.has(commandClass))
		{
			var fields = Type.getInstanceFields(commandClass);
			var verified = Lambda.has(fields, "execute");
			
			if (verified)
			{
				verifiedCommandClasses.add(commandClass);
			}
			else
			{
				throw new ContextError(ContextError.E_COMMANDMAP_NOIMPL + ' - ' + Type.getClassName(commandClass));
			}
		}
	}
	
	/**
	 * Event Handler
	 *
	 * @param event The <code>Event</code>
	 * @param commandClass The Class to construct and execute
	 * @param oneshot Should this command mapping be removed after execution?
     * @return <code>true</code> if the event was routed to a Command and the Command was executed,
     *         <code>false</code> otherwise
	 */
	function routeEventToCommand(event:Event, commandClass:Class<Dynamic>, oneshot:Bool, originalEventClass:Class<Dynamic>):Bool
	{
		if (!(Std.is(event, originalEventClass))) return false;
		
		execute(commandClass, event);
		
		if (oneshot) unmapEvent(event.type, commandClass, originalEventClass);
		
		return true;
	}
}
