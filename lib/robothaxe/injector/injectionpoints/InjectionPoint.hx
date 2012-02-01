/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.injector.injectionpoints;

import robothaxe.injector.Injector;
import haxe.rtti.CType;

class InjectionPoint
{
	public function new(meta:Dynamic, injector:Injector)
	{
		initializeInjection(meta);
	}
	
	public function applyInjection(target:Dynamic, injector:Injector):Dynamic
	{
		return target;
	}

	function initializeInjection(meta:Dynamic):Void
	{

	}
}
