/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.core;

import robothaxe.event.IEventDispatcher;

/**
 * The Robotlegs Context contract
 */
interface IContext
{
	/**
	 * The <code>IContext</code>'s <code>IEventDispatcher</code>
	 */
	var eventDispatcher(default, null):IEventDispatcher;

}
