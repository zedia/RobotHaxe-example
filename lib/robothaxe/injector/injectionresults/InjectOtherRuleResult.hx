/*
* Copyright (c) 2010 the original author or authors
*
* Permission is hereby granted to use, modify, and distribute this file
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.injector.injectionresults;

import robothaxe.injector.InjectionConfig;
import robothaxe.injector.Injector;

class InjectOtherRuleResult extends InjectionResult
{
	var rule:InjectionConfig;
	
	public function new(rule:InjectionConfig)
	{
		super();
		this.rule = rule;
	}
	
	public override function getResponse(injector:Injector):Dynamic
	{
		return rule.getResponse(injector);
	}
}
