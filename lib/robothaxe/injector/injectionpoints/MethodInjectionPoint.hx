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

class MethodInjectionPoint extends InjectionPoint
{
	var methodName:String;
	var _parameterInjectionConfigs:Array<Dynamic>;
	var requiredParameters:Int;
	
	public function new(meta:Dynamic, ?injector:Injector=null)
	{
		requiredParameters = 0;
		super(meta, injector);
	}
	
	override public function applyInjection(target:Dynamic, injector:Injector):Dynamic
	{
		var parameters: Array<Dynamic> = gatherParameterValues(target, injector);
		var method: Dynamic = Reflect.field(target, methodName);
		Reflect.callMethod(target, method, parameters);
		return target;
	}
	
	override function initializeInjection(meta:Dynamic):Void
	{
		methodName = meta.name[0];
		gatherParameters(meta);
	}
	
	function gatherParameters(meta:Dynamic):Void
	{
		var nameArgs = meta.inject;
		var args:Array<Dynamic> = meta.args;

		if (nameArgs == null) nameArgs = [];
		_parameterInjectionConfigs = [];

		var i = 0;
		for (arg in args)
		{
			var injectionName = "";

			if (i < nameArgs.length)
			{
				injectionName = nameArgs[i];
			}

			var parameterTypeName = arg.type;

			if (arg.opt)
			{
				if (parameterTypeName == "Dynamic")
				{
					//TODO: Find a way to trace name of affected class here
					throw new InjectorError('Error in method definition of injectee. Required parameters can\'t have non class type.');
				}
			}
			else
			{
				requiredParameters++;
			}

			_parameterInjectionConfigs.push(new ParameterInjectionConfig(parameterTypeName, injectionName));
			
			i++;
		}
	}
	
	function gatherParameterValues(target:Dynamic, injector:Injector):Array<Dynamic>
	{
		var parameters: Array<Dynamic> = [];
		var length: Int = _parameterInjectionConfigs.length;

		for (i in 0...length)
		{
			var parameterConfig = _parameterInjectionConfigs[i];
			var config = injector.getMapping(Type.resolveClass(parameterConfig.typeName), parameterConfig.injectionName);
			
			var injection:Dynamic = config.getResponse(injector);
			if (injection == null)
			{
				if (i >= requiredParameters)
				{
					break;
				}

				throw(new InjectorError('Injector is missing a rule to handle injection into target ' + Type.getClassName(target) + '. Target dependency: ' + Type.getClassName(config.request) + ', method: ' + methodName + ', parameter: ' + (i + 1) + ', named: ' + parameterConfig.injectionName));
			}
			
			parameters[i] = injection;
		}

		return parameters;
	}
}

class ParameterInjectionConfig
{
	public var typeName:String;
	public var injectionName:String;

	public function new(typeName:String, injectionName:String)
	{
		this.typeName = typeName;
		this.injectionName = injectionName;
	}
}