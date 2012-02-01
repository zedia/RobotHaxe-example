/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.injector.injectionpoints;

import robothaxe.injector.Injector;
import haxe.rtti.CType;

class PostConstructInjectionPoint extends InjectionPoint
{
	public var order(default, null):Int;
	
	var methodName:String;
	
	public function new(meta:Dynamic, ?injector:Injector=null)
	{
		order = 0;
		super(meta, injector);
	}
	
	public override function applyInjection(target:Dynamic, injector:Injector):Dynamic
	{
		Reflect.callMethod(target, Reflect.field(target, methodName), []);
		return target;
	}
	
	override function initializeInjection(meta:Dynamic):Void
	{
		methodName = meta.name[0];

		if (meta.post != null)
		{
			order = meta.post[0];
		}
	}
}
