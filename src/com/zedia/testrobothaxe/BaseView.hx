package com.zedia.testrobothaxe;

/**
 * ...
 * @author me
 */
import nme.display.DisplayObjectContainer;
import robothaxe.core.IViewContainer;

class BaseView implements IViewContainer{

	public var viewAdded:Dynamic -> Void;
	public var viewRemoved:Dynamic -> Void;
	private var _view:DisplayObjectContainer;
	
	@inject("injectionName")
	public var injectionPoint:String;
	
	public function new(view:DisplayObjectContainer) {
		_view = view;
	}
	public function addView(view:Dynamic):Void {
		_view.addChild(view);
		if (viewAdded != null){
			viewAdded(view);
		}
	}
	public function removeView(view:Dynamic):Void {
		_view.removeChild(view);
		if (viewRemoved != null){
			viewRemoved(view);
		}
	}
	public function isAdded(view:Dynamic):Bool {
		return _view.contains(view);
	}
}