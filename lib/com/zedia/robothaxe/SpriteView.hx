package com.zedia.robothaxe;

/**
 * @author Dominic Gelineau
 * 
 * When I normally use RobotLegs, all my views are Sprites, now, since I have to implement IViewContainer
 * I made this class that all my views will extends instead of extending Sprite
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