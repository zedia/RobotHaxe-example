package com.zedia.testrobothaxe.controller;

/**
 * ...
 * @author me
 */
import robothaxe.mvcs.Command;
import com.zedia.testrobothaxe.view.components.TestView;
import com.zedia.testrobothaxe.view.TestViewMediator;

class CreateMediatorsCommand extends Command {

	public function new( ) {super();}
	
	override public function execute():Void {
		mediatorMap.mapView(TestView, TestViewMediator);
		
		cast(contextView, BaseView).addView(new TestView());
	}
}