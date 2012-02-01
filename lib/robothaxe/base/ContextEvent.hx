/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package robothaxe.base;

import robothaxe.event.Event;

/**
 * A framework Event implementation
 */
class ContextEvent extends Event
{
	public var body(getBody, null):Dynamic;

	public static var STARTUP:String = 'startup';
	public static var STARTUP_COMPLETE:String = 'startupComplete';
	
	public static var SHUTDOWN:String = 'shutdown';
	public static var SHUTDOWN_COMPLETE:String = 'shutdownComplete';
	
	var _body:Dynamic;
	
	/**
	 * A generic context <code>Event</code> implementation
	 *
	 * <p>This class is handy for prototype work, but it's usage is not considered Best Practice</p>
	 *
	 * @param type The <code>Event</code> type
	 * @param body A loosely typed payload
	 */
	public function new(type:String, ?body:Dynamic = null)
	{
		super(type);
		_body = body;
	}
	
	/**
	 * Loosely typed <code>Event</code> payload
	 * @return Payload
	 */
	public function getBody():Dynamic
	{
		return _body;
	}
	
	public override function clone():Event
	{
		return new ContextEvent(type, body);
	}

}
