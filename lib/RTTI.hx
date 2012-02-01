#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
#end

class RTTI
{
	#if macro
	public static function generate()
	{
		Context.onGenerate(function(types){
			for (type in types)
			{
				switch (type)
				{
					case TInst(t, params):
					processInst(t, params);

					default:
				}
			}
		});
	}

	static function processInst(t:Ref<ClassType>, params:Array<Type>)
	{
		var ref = t.get();

		if (ref.isInterface)
		{
			ref.meta.add("interface", [], ref.pos);
		}

		if (ref.constructor != null)
		{
			processField(ref, ref.constructor.get());
		}

		var fields = ref.fields.get();

		for (field in fields)
		{
			processField(ref, field);
		}
	}

	static function processField(ref:ClassType, field:ClassField)
	{
		if (!field.isPublic) return;

		var meta = field.meta.get();
		var abort = true;

		for (m in meta)
		{
			var name = m.name;
			if (name == "inject" || name == "post")
			{
				abort = false;
				break;
			}
		}
		
		if (abort) return;

		switch (field.kind)
		{
			case FVar(read, write):
			switch (field.type)
			{
				// might need to recurse into typedefs here, incase people are silly - dp
				case TType(t, params):
				var def = t.get();
				switch (def.type)
				{
					case TInst(t, params):
					processProperty(ref, field, t.get(), params);
					default:
				}

				case TInst(t, params):
				processProperty(ref, field, t.get(), params);
				default:
			}

			switch (write)
			{
				case AccCall(m):
				field.meta.add("setter", [Context.parse('"' + m + '"', ref.pos)], ref.pos);
				default:
			}

			case FMethod(k):
			switch (field.type)
			{
				case TFun(args, ret):
				var types = [];
				for (arg in args)
				{
					switch (arg.t)
					{
						case TInst(t, params):
						var type = t.get();
						var pack = type.pack;
						var opt = arg.opt ? "true" : "false";
						pack.push(type.name);
						var typeName = pack.join(".");
						types.push(Context.parse('{type:"' + pack.join(".") + '",opt:' + opt + '}', ref.pos));
						default:
					}
				}

				field.meta.add("args", types, ref.pos);
				field.meta.add("name", [Context.parse('"' + field.name + '"', ref.pos)], ref.pos);
				
				default:
			}
			
			default:
		}
	}

	static function processProperty(ref:ClassType, field:ClassField, type:ClassType, params)
	{
		var pack = type.pack;
		pack.push(type.name);
		
		field.meta.add("type", [Context.parse('"' + pack.join(".") + '"', ref.pos)], ref.pos);
		field.meta.add("name", [Context.parse('"' + field.name + '"', ref.pos)], ref.pos);
	}
	#end
}