package com.zedia.testrobothaxe.view;

/**
 * ...
 * @author me
 */
import robothaxe.mvcs.Mediator;
import com.zedia.testrobothaxe.view.components.TestView;

class TestViewMediator extends Mediator {

	@inject
	public var view:TestView;
	
	public function new()
	{
		super();
	}
	
	override public function onRegister():Void {
		trace ("the mediator for TestView was created");
	}
	
}