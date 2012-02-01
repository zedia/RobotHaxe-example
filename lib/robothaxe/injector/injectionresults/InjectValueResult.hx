/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.injector.injectionresults;

import robothaxe.injector.Injector;

class InjectValueResult extends InjectionResult
{
	var value:Dynamic;
	
	public function new(value:Dynamic)
	{
		super();
		this.value = value;
	}
	
	public override function getResponse(injector:Injector):Dynamic
	{
		return value;
	}
}
