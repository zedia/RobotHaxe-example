/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.injector.injectionpoints;

import robothaxe.injector.Injector;
import haxe.rtti.CType;

class NoParamsConstructorInjectionPoint extends InjectionPoint
{
	public function new()
	{
		super(null, null);
	}
	
	public override function applyInjection(target:Dynamic, injector:Injector):Dynamic
	{
		return Type.createInstance(target, []);
	}
}
