/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.injector.injectionpoints;

import robothaxe.injector.InjectionConfig;
import robothaxe.injector.Injector;
import robothaxe.injector.InjectorError;
import haxe.rtti.CType;

class PropertyInjectionPoint extends InjectionPoint
{
	var propertyName:String;
	var propertyType:String;
	var injectionName:String;
	var hasSetter:Bool;

	public function new(meta:Dynamic, ?injector:Injector=null)
	{
		super(meta, null);
	}
	
	public override function applyInjection(target:Dynamic, injector:Injector):Dynamic
	{
		var injectionConfig:InjectionConfig = injector.getMapping(Type.resolveClass(propertyType), injectionName);
		var injection:Dynamic = injectionConfig.getResponse(injector);

		if (injection == null)
		{
			throw(new InjectorError('Injector is missing a rule to handle injection into property "' + propertyName + '" of object "' + target + '". Target dependency: "' + propertyType + '", named "' + injectionName + '"'));
		}

		if (hasSetter)
		{
			var setter = Reflect.field(target, propertyName);
			Reflect.callMethod(target, setter, [injection]);
		}
		else
		{
			Reflect.setField(target, propertyName, injection);
		}
		
		return target;
	}
	
	override function initializeInjection(meta:Dynamic):Void
	{
		propertyType = meta.type[0];
		hasSetter = (meta.setter != null);

		if (hasSetter)
		{
			propertyName = meta.setter[0];
		}
		else
		{
			propertyName = meta.name[0];
		}

		if (meta.inject == null)
		{
			injectionName = "";
		}
		else
		{
			injectionName = meta.inject[0];
		}
	}
}
