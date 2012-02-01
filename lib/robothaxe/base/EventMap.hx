/*
* Copyright (c) 2009 the original author or authors
*
* Permission is hereby granted to use, modify, and distribute this file
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.base;

import robothaxe.event.Event;
import robothaxe.event.IEventDispatcher;

import robothaxe.core.IEventMap;

/**
 * An abstract <code>IEventMap</code> implementation
 */
class EventMap implements IEventMap
{
	/**
	 * The <code>IEventDispatcher</code>
	 */
	
	public var dispatcherListeningEnabled:Bool;
	/**
	 * The <code>IEventDispatcher</code>
	 */
	var eventDispatcher:IEventDispatcher;
	
	/**
	 * @private
	 */
	var listeners:Array<Dynamic>;
	
	//---------------------------------------------------------------------
	//  Constructor
	//---------------------------------------------------------------------
	
	/**
	 * Creates a new <code>EventMap</code> object
	 *
	 * @param eventDispatcher An <code>IEventDispatcher</code> to treat as a bus
	 */
	public function new(eventDispatcher:IEventDispatcher)
	{
		dispatcherListeningEnabled = true;
		listeners = [];
		this.eventDispatcher = eventDispatcher;
	}
	
	//---------------------------------------------------------------------
	//  API
	//---------------------------------------------------------------------
	
	/**
	 * The same as calling <code>addEventListener</code> directly on the <code>IEventDispatcher</code>,
	 * but keeps a list of listeners for easy (usually automatic) removal.
	 *
	 * @param dispatcher The <code>IEventDispatcher</code> to listen to
	 * @param type The <code>Event</code> type to listen for
	 * @param listener The <code>Event</code> handler
	 * @param eventClass Optional Event class for a stronger mapping. Defaults to <code>robothaxe.event.Event</code>.
	 * @param useCapture
	 * @param priority
	 * @param useWeakReference
	 */
	public function mapListener(dispatcher:IEventDispatcher, type:String, listener:Dynamic, ?eventClass:Class<Dynamic>=null, ?useCapture:Bool=false, ?priority:Int=0, ?useWeakReference:Bool=true):Void
	{
		if (dispatcherListeningEnabled == false && dispatcher == eventDispatcher)
		{
			throw new ContextError(ContextError.E_EVENTMAP_NOSNOOPING);
		}

		if (eventClass == null) eventClass = Event;
		
		for (params in listeners)
		{
			if (params.dispatcher == dispatcher
				&& params.type == type
				&& Reflect.compareMethods(params.listener, listener)
				&& params.useCapture == useCapture
				&& params.eventClass == eventClass)
			{
				return;
			}
		}
		
		var me = this;
		var eventCallback:Dynamic = function(event:Event)
		{
			me.routeEventToListener(event, listener, eventClass);
		};

		var params =
		{
			dispatcher: dispatcher,
			type: type,
			listener: listener,
			eventClass: eventClass,
			eventCallback: eventCallback,
			useCapture: useCapture
		};

		listeners.push(params);
		dispatcher.addEventListener(type, eventCallback, useCapture, priority, useWeakReference);
	}
	
	/**
	 * The same as calling <code>removeEventListener</code> directly on the <code>IEventDispatcher</code>,
	 * but updates our local list of listeners.
	 *
	 * @param dispatcher The <code>IEventDispatcher</code>
	 * @param type The <code>Event</code> type
	 * @param listener The <code>Event</code> handler
	 * @param eventClass Optional Event class for a stronger mapping. Defaults to <code>robothaxe.event.Event</code>.
	 * @param useCapture
	 */
	public function unmapListener(dispatcher:IEventDispatcher, type:String, listener:Dynamic, ?eventClass:Class<Dynamic> = null, ?useCapture:Bool = false):Void
	{
		if (eventClass == null) eventClass = Event;
		
		var params:Dynamic;
		var i:Int = listeners.length;
		while (i-- > 0)
		{
			params = listeners[i];
			if (params.dispatcher == dispatcher
				&& params.type == type
				&& Reflect.compareMethods(params.listener, listener)
				&& params.useCapture == useCapture
				&& params.eventClass == eventClass)
			{
				dispatcher.removeEventListener(type, params.eventCallback, useCapture);
				listeners.splice(i, 1);
				return;
			}
		}
	}
	
	/**
	 * Removes all listeners registered through <code>mapListener</code>
	 */
	public function unmapListeners():Void
	{
		var params:Dynamic;
		var dispatcher:IEventDispatcher;
		while (params = listeners.pop())
		{
			dispatcher = params.dispatcher;
			dispatcher.removeEventListener(params.type, params.eventCallback, params.useCapture);
		}
	}
	
	//---------------------------------------------------------------------
	//  Internal
	//---------------------------------------------------------------------
	
	/**
	 * Event Handler
	 *
	 * @param event The <code>Event</code>
	 * @param listener
	 * @param originalEventClass
	 */
	function routeEventToListener(event:Event, listener:Dynamic, originalEventClass:Class<Dynamic>):Void
	{
		if (Std.is( event, originalEventClass))
		{
			listener(event);
		}
	}
}
