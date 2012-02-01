package com.zedia.testrobothaxe.view.components;

/**
 * ...
 * @author me
 */
import nme.display.Sprite;
import robothaxe.core.IViewContainer;

class SpriteView extends Sprite, implements IViewContainer  {
	public var viewAdded:Dynamic -> Void;
	public var viewRemoved:Dynamic -> Void;
	
	public function new() {
		super();
	}
	public function addView(view:Dynamic):Void {
		addChild(view);
		viewAdded(view);
	}
	public function removeView(view:Dynamic):Void {
		removeChild(view);
		viewRemoved(view);
	}
	public function isAdded(view:Dynamic):Bool {
		return contains(view);
	}
}