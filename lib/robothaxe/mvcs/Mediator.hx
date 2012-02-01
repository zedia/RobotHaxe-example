/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.mvcs;

import robothaxe.event.Event;
import robothaxe.event.IEventDispatcher;
import robothaxe.base.EventMap;
import robothaxe.base.MediatorBase;
import robothaxe.core.IEventMap;
import robothaxe.core.IMediatorMap;
import robothaxe.core.IViewContainer;

/**
 * Abstract MVCS <code>IMediator</code> implementation
 */
class Mediator extends MediatorBase
{
	@inject
	public var eventDispatcher:IEventDispatcher;

	@inject
	public var contextView:IViewContainer;
	
	@inject
	public var mediatorMap:IMediatorMap;
	
	public function new()
	{
		super();
	}
	
	/**
	 * @inheritDoc
	 */
	public override function preRemove():Void
	{
		if (eventMap != null)
		{
			eventMap.unmapListeners();
		}

		super.preRemove();
	}
	
	/**
	 * Local EventMap
	 *
	 * @return The EventMap for this Actor
	 */
	public var eventMap(get_eventMap, null):IEventMap;
	function get_eventMap():IEventMap
	{
		if (eventMap == null)
		{
			eventMap = new EventMap(eventDispatcher);
		}

		return eventMap;
	}
	
	/**
	 * Dispatch helper method
	 *
	 * @param event The Event to dispatch on the <code>IContext</code>'s <code>IEventDispatcher</code>
	 */
	function dispatch(event:Event):Bool
	{
	    if (eventDispatcher.hasEventListener(event.type))
	    {
		    return eventDispatcher.dispatchEvent(event);
		}

	 	return false;
	}
	
	/**
	 * Syntactical sugar for mapping a listener to the <code>viewComponent</code> 
	 * 
	 * @param type
	 * @param listener
	 * @param eventClass
	 * @param useCapture
	 * @param priority
	 * @param useWeakReference
	 * 
	 */		
	function addViewListener(type:String, listener:Dynamic, ?eventClass:Class<Dynamic>=null, ?useCapture:Bool=false, ?priority:Int=0, ?useWeakReference:Bool=true):Void 
	{
		//eventMap.mapListener(viewComponent, type, listener, eventClass, useCapture, priority, useWeakReference);
	}
	
	/**
	 * Syntactical sugar for mapping a listener to an <code>IEventDispatcher</code> 
	 * 
	 * @param dispatcher
	 * @param type
	 * @param listener
	 * @param eventClass
	 * @param useCapture
	 * @param priority
	 * @param useWeakReference
	 * 
	 */		
	function addContextListener(type:String, listener:Dynamic, ?eventClass:Class<Dynamic>=null, ?useCapture:Bool=false, ?priority:Int=0, ?useWeakReference:Bool=true):Void
 	{
		eventMap.mapListener(eventDispatcher, type, listener, eventClass, useCapture, priority, useWeakReference);
	}
}
