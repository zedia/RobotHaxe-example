/*
* Copyright (c) 2009 the original author or authors
*
* Permission is hereby granted to use, modify, and distribute this file
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.injector;

import robothaxe.core.IReflector;

class Reflector implements IReflector
 {
	public function new(){}

	public function classExtendsOrImplements(classOrClassName:Dynamic, superClass:Class<Dynamic>):Bool
	{
        var actualClass:Class<Dynamic> = null;
		
        if (Std.is(classOrClassName, Class))
        {
            actualClass = cast(classOrClassName, Class<Dynamic>);
        }
        else if (Std.is(classOrClassName, String))
        {
            try
            {
                actualClass = Type.resolveClass(cast(classOrClassName, String));
            }
            catch (e:Dynamic)
            {
                throw "The class name " + classOrClassName + " is not valid because of " + e + "\n" + e.getStackTrace();
            }
        }

        if (actualClass == null)
        {
            throw "The parameter classOrClassName must be a Class or fully qualified class name.";
        }

        var classInstance = Type.createEmptyInstance(actualClass);
        return Std.is(classInstance, superClass);
	}

	public function getClass(value:Dynamic):Class<Dynamic>
	{
		if (Std.is(value, Class))
		{
			return value;
		}

		return Type.getClass(value);
	}
	
	public function getFQCN(value:Dynamic):String
	{
		var fqcn:String;

		if (Std.is(value, String))
		{
			return cast(value, String);
		}

		return Type.getClassName(value);
	}
}
