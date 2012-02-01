/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.mvcs;

import robothaxe.event.Event;
import robothaxe.event.IEventDispatcher;
import robothaxe.base.CommandMap;
import robothaxe.base.ContextBase;
import robothaxe.base.ContextEvent;
import robothaxe.base.EventMap;
import robothaxe.base.MediatorMap;
import robothaxe.base.ViewMap;
import robothaxe.core.ICommandMap;
import robothaxe.core.IContext;
import robothaxe.core.IEventMap;
import robothaxe.core.IInjector;
import robothaxe.core.IMediatorMap;
import robothaxe.core.IReflector;
import robothaxe.core.IViewMap;
import robothaxe.core.IViewContainer;
import robothaxe.injector.Injector;
import robothaxe.injector.Reflector;

/**
 * Dispatched by the <code>startup()</code> method when it finishes
 * executing.
 * 
 * <p>One common pattern for application startup/bootstrapping makes use
 * of the <code>startupComplete</code> event. In this pattern, you do the
 * following:</p>
 * <ul>
 *   <li>Override the <code>startup()</code> method in your Context 
 *       subclass and set up application mappings in your 
 *       <code>startup()</code> override as you always do in Robotlegs.</li>
 *   <li>Create commands that perform startup/bootstrapping operations
 *       such as loading the initial data, checking for application updates,
 *       etc.</li>
 *   <li><p>Map those commands to the <code>ContextEvent.STARTUP_COMPLETE</code>
 *       event:</p>
 *       <listing>commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, LoadInitialDataCommand, ContextEvent, true):</listing>
 *       </li>
 *   <li>Dispatch the <code>startupComplete</code> (<code>ContextEvent.STARTUP_COMPLETE</code>)
 *       event from your <code>startup()</code> override. You can do this
 *       in one of two ways: dispatch the event yourself, or call 
 *       <code>super.startup()</code>. (The Context class's 
 *       <code>startup()</code> method dispatches the 
 *       <code>startupComplete</code> event.)</li>
 * </ul>
 * 
 * @eventType robothaxe.base.ContextEvent.STARTUP_COMPLETE
 * 
 * @see #startup()
 */
/*[Event(name="startupComplete", type="robothaxe.base.ContextEvent")]*/


/**
 * Abstract MVCS <code>IContext</code> implementation
 */
class Context extends ContextBase, implements IContext
{
	public var contextView(default, set_contextView):IViewContainer;
	
	public var commandMap(get_commandMap, null):ICommandMap;

	public var injector(get_injector, null):IInjector;
	
	public var mediatorMap(get_mediatorMap, null):IMediatorMap;
	
	public var reflector(get_reflector, null):IReflector;
	
	public var viewMap(get_viewMap, null):IViewMap;
	
	/**
	 * @private
	 */
	var autoStartup:Bool;
	
	//---------------------------------------------------------------------
	//  Constructor
	//---------------------------------------------------------------------
	
	/**
	 * Abstract Context Implementation
	 *
	 * <p>Extend this class to create a Framework or Application context</p>
	 *
	 * @param contextView The root view node of the context. The context will listen for ADDED_TO_STAGE events on this node
	 * @param autoStartup Should this context automatically invoke it's <code>startup</code> method when it's <code>contextView</code> arrives on Stage?
	 */
	public function new(?contextView:IViewContainer = null, ?autoStartup:Bool = true)
	{
		super();

		this.autoStartup = autoStartup;
		this.contextView = contextView;
	}
	
	//---------------------------------------------------------------------
	//  API
	//---------------------------------------------------------------------
	
	/**
	 * The Startup Hook
	 *
	 * <p>Override this in your Application context</p>
	 * 
	 * @event startupComplete ContextEvent.STARTUP_COMPLETE Dispatched at the end of the
	 *                        <code>startup()</code> method's execution. This
	 *                        is often used to trigger startup/bootstrapping
	 *                        commands by wiring them to this event and 
	 *                        calling <code>super.startup()</code> in the 
	 *                        last line of your <code>startup()</code>
	 *                        override.
	 */
	public function startup():Void
	{
		dispatchEvent(new ContextEvent(ContextEvent.STARTUP_COMPLETE));
	}
	
	/**
	 * The Startup Hook
	 *
	 * <p>Override this in your Application context</p>
	 */
	public function shutdown():Void
	{
		dispatchEvent(new ContextEvent(ContextEvent.SHUTDOWN_COMPLETE));
	}
	
	/**
	 * @private
	 */
	public function set_contextView(value:IViewContainer):IViewContainer
	{
		if (contextView != value)
		{
			contextView = value;
			// Hack: We have to clear these out and re-map them
			commandMap = null;
			mediatorMap = null;
			viewMap = null;

			mapInjections();
			checkAutoStartup();
		}

		return value;
	}
	
	/**
	 * The <code>IInjector</code> for this <code>IContext</code>
	 */
	function get_injector():IInjector
	{
		if (injector == null)
		{
			return createInjector();
		}

		return injector;
	}
	
	/**
	 * The <code>IReflector</code> for this <code>IContext</code>
	 */
	function get_reflector():IReflector
	{
		if (reflector == null)
		{
			reflector = new Reflector();
		}

		return reflector;
	}
	
	/**
	 * The <code>ICommandMap</code> for this <code>IContext</code>
	 */
	function get_commandMap():ICommandMap
	{
		if (commandMap == null)
		{
			commandMap = new CommandMap(eventDispatcher, createChildInjector(), reflector);
		}

		return commandMap;
	}
	
	/**
	 * The <code>IMediatorMap</code> for this <code>IContext</code>
	 */
	function get_mediatorMap():IMediatorMap
	{
		if (mediatorMap == null)
		{
			mediatorMap = new MediatorMap(contextView, createChildInjector(), reflector);
		}

		return mediatorMap;
	}
	
	/**
	 * The <code>IViewMap</code> for this <code>IContext</code>
	 */
	function get_viewMap():IViewMap
	{
		if (viewMap == null)
		{
			viewMap = new ViewMap(contextView, injector);
		}

		return viewMap;
	}
	
	/**
	 * Injection Mapping Hook
	 *
	 * <p>Override this in your Framework context to change the default configuration</p>
	 *
	 * <p>Beware of collisions in your container</p>
	 */
	function mapInjections():Void
	{
		injector.mapValue(IReflector, reflector);
		injector.mapValue(IInjector, injector);
		injector.mapValue(IEventDispatcher, eventDispatcher);
		injector.mapValue(IViewContainer, contextView);
		injector.mapValue(ICommandMap, commandMap);
		injector.mapValue(IMediatorMap, mediatorMap);
		injector.mapValue(IViewMap, viewMap);
		injector.mapClass(IEventMap, EventMap);
	}
	
	/**
	 * @private
	 */
	function checkAutoStartup():Void
	{
		if (autoStartup && contextView != null)
		{
			startup();
			//contextView.stage != null ? startup() : contextView.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}
	}
	
	/**
	 * @private
	 */
	function onAddedToStage(e:Event):Void
	{
		//contextView.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		startup();
	}
	
	/**
	 * @private
	 */
	function createInjector():IInjector
	{
		injector = new Injector();
		return injector;
	}
	
	/**
	 * @private
	 */
	function createChildInjector():IInjector
	{
		return injector.createChildInjector();
	}
}
