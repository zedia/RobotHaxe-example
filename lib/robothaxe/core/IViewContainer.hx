package robothaxe.core;

interface IViewContainer
{
	var viewAdded:Dynamic -> Void;
	var viewRemoved:Dynamic -> Void;
	
	function isAdded(view:Dynamic):Bool;
	
}