/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.injector.injectionpoints;

import robothaxe.injector.Injector;

class ConstructorInjectionPoint extends MethodInjectionPoint
{
	public function new(meta:Dynamic, forClass:Class<Dynamic>, ?injector:Injector=null)
	{
		super(meta, injector);
	}
	
	public override function applyInjection(target:Dynamic, injector:Injector):Dynamic
	{
		var ofClass:Class<Dynamic> = target;
		var withArgs:Array<Dynamic> = gatherParameterValues(target, injector);
		return Type.createInstance(ofClass, withArgs);
	}

	override function initializeInjection(meta:Dynamic):Void
	{
		methodName = "new";
		gatherParameters(meta);
	}
}
