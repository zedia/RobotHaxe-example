package com.zedia.testrobothaxe.view.components;

/**
 * ...
 * @author me
 */
import com.zedia.testrobothaxe.view.components.SpriteView;
 
class TestView extends SpriteView{

	public function new() {
		super();
		graphics.beginFill(0xff0000);
		graphics.drawRect(0, 0, 100, 100);
		graphics.endFill();
		
	}
	
}