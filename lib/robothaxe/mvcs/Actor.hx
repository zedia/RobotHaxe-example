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
import robothaxe.core.IEventMap;

/**
 * Abstract MVCS <code>IActor</code> implementation
 *
 * <p>As part of the MVCS implementation the <code>Actor</code> provides core functionality to an applications
 * various working parts.</p>
 *
 * <p>Some possible uses for the <code>Actor</code> include, but are no means limited to:</p>
 *
 * <ul>
 * <li>Service classes</li>
 * <li>Model classes</li>
 * <li>Controller classes</li>
 * <li>Presentation model classes</li>
 * </ul>
 *
 * <p>Essentially any class where it might be advantagous to have basic dependency injection supplied is a candidate
 * for extending <code>Actor</code>.</p>
 *
 */
class Actor
{
	public function new(){}

	@inject
	public var eventDispatcher:IEventDispatcher;
	
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
	 * @param event The <code>Event</code> to dispatch on the <code>IContext</code>'s <code>IEventDispatcher</code>
	 */
	function dispatch(event:Event):Bool
	{
		if(eventDispatcher.hasEventListener(event.type))
		{
			return eventDispatcher.dispatchEvent(event);
		}
		
		return false;
	}
}
