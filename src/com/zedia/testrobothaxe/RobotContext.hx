package com.zedia.testrobothaxe;

/**
 * ...
 * @author me
 */
import nme.events.Event;
import robothaxe.mvcs.Context;
import robothaxe.core.IViewContainer;
import com.zedia.testrobothaxe.view.components.TestView;
import com.zedia.testrobothaxe.BaseView;
import com.zedia.testrobothaxe.controller.CreateMediatorsCommand;
import com.zedia.testrobothaxe.model.ApplicationModel;

class RobotContext extends Context {

	public function new(?contextView:IViewContainer = null, ?autoStartup:Bool = true) {
		super (contextView, autoStartup);
		
		injector.mapSingleton(ApplicationModel);
		var model:ApplicationModel = injector.getInstance(ApplicationModel);
		
		commandMap.mapEvent("SOMETHING", CreateMediatorsCommand);
		
		dispatchEvent(new Event("SOMETHING"));
	}
}