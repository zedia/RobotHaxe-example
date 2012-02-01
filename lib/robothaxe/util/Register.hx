package robothaxe.util;

class Register<T>
{
	var list:List<T>;

	public function new()
	{
		list = new List<T>();
	}

	public function has(value:T):Bool
	{
		for (v in list)
		{
			if (v == value)
			{
				return true;
			}
		}

		return false;
	}

	public function add(value:T)
	{
		if (has(value)) return;
		list.add(value);
	}

	public function remove(value:T)
	{
		list.remove(value);
	}

	public function clear()
	{
		list.clear();
	}
}