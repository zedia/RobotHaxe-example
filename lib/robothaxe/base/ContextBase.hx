/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package robothaxe.base;

import robothaxe.event.Event;
import robothaxe.event.EventDispatcher;
import robothaxe.event.IEventDispatcher;

import robothaxe.core.IContext;
	
/**
 * An abstract <code>IContext</code> implementation
 */
class ContextBase implements IContext, implements IEventDispatcher
{
	/**
	 * @private
	 */
	public var eventDispatcher(default, null):IEventDispatcher;
	
	//---------------------------------------------------------------------
	//  Constructor
	//---------------------------------------------------------------------
	
	/**
	 * Abstract Context Implementation
	 *
	 * <p>Extend this class to create a Framework or Application context</p>
	 */
	public function new()
	{
		eventDispatcher = new EventDispatcher(this);
	}
	
	//---------------------------------------------------------------------
	//  EventDispatcher Boilerplate
	//---------------------------------------------------------------------
	
	/**
	 * @private
	 */
	public function addEventListener(type:String, listener:Dynamic -> Void, ?useCapture:Bool = false, ?priority:Int = 0, ?useWeakReference:Bool = false):Void
	{
		eventDispatcher.addEventListener(type, listener, useCapture, priority);
	}
	
	/**
	 * @private
	 */
	public function dispatchEvent(event:Event):Bool
	{
		if(eventDispatcher.hasEventListener(event.type))
			return eventDispatcher.dispatchEvent(event);
		return false;
	}
	
	/**
	 * @private
	 */
	public function hasEventListener(type:String):Bool
	{
		return eventDispatcher.hasEventListener(type);
	}
	
	/**
	 * @private
	 */
	public function removeEventListener(type:String, listener:Dynamic -> Void, ?useCapture:Bool = false):Void
	{
		eventDispatcher.removeEventListener(type, listener, useCapture);
	}
	
	/**
	 * @private
	 */
	public function willTrigger(type:String):Bool
	{
		return eventDispatcher.willTrigger(type);
	}
}
