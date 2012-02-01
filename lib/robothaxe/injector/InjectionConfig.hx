/*
* Copyright (c) 2009 the original author or authors
*
* Permission is hereby granted to use, modify, and distribute this file
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.injector;

import robothaxe.injector.injectionresults.InjectionResult;

class InjectionConfig
{
	public var request:Class<Dynamic>;
	public var injectionName:String;

	var injector:Injector;
	var result:InjectionResult;
	
	public function new(request:Class<Dynamic>, injectionName:String)
	{
		this.request = request;
		this.injectionName = injectionName;
	}

	public function getResponse(injector:Injector):Dynamic
	{
		if (this.injector != null) injector = this.injector;

		if (result != null)
		{
			return result.getResponse(injector);
		}
		
		var parentConfig = injector.getAncestorMapping(request, injectionName);

		if (parentConfig != null)
		{
			return parentConfig.getResponse(injector);
		}

		return null;
	}

	public function hasResponse(injector:Injector):Bool
	{
		return (result != null);
	}

	public function hasOwnResponse():Bool
	{
		return (result != null);
	}

	public function setResult(result:InjectionResult):Void
	{
		if (this.result != null && result != null)
		{
			trace('Warning: Injector already has a rule for type "' + Type.getClassName(request) + '", named "' + injectionName + '".\nIf you have overwritten this mapping intentionally you can use "injector.unmap()" prior to your replacement mapping in order to avoid seeing this message.');
		}

		this.result = result;
	}

	public function setInjector(injector:Injector):Void
	{
		this.injector = injector;
	}
}
