/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.injector;

class InjectorError
{
	public var message:String;
	
	public function new(message:String)
	{
		this.message = message;
	}

	public function toString()
	{
		return message;
	}
}
