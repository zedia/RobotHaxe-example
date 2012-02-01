/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.mvcs;

import robothaxe.event.Event;
import robothaxe.event.IEventDispatcher;
import robothaxe.core.ICommandMap;
import robothaxe.core.IInjector;
import robothaxe.core.IMediatorMap;
import robothaxe.core.IViewContainer;

/**
 * Abstract MVCS command implementation
 */
class Command
{
	@inject
	public var contextView:IViewContainer;
	
	@inject
	public var commandMap:ICommandMap;
	
	@inject
	public var eventDispatcher:IEventDispatcher;
	
	@inject
	public var injector:IInjector;
	
	@inject
	public var mediatorMap:IMediatorMap;
	
	public function new()
	{
	}
	
	/**
	 * @inheritDoc
	 */
	public function execute():Void
	{
	}
	
	/**
	 * Dispatch helper method
	 *
	 * @param event The <code>Event</code> to dispatch on the <code>IContext</code>'s <code>IEventDispatcher</code>
	 */
		function dispatch(event:Event):Bool
		{
		    if(eventDispatcher.hasEventListener(event.type))
		        return eventDispatcher.dispatchEvent(event);
		 	return false;  
		}
}
