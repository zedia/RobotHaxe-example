/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.injector.injectionresults;

import robothaxe.injector.Injector;

class InjectClassResult extends InjectionResult
{
	var responseType:Class<Dynamic>;
	
	public function new(responseType:Class<Dynamic>)
	{
		super();
		this.responseType = responseType;
	}
	
	public override function getResponse(injector:Injector):Dynamic
	{
		return injector.instantiate(responseType);
	}
}
