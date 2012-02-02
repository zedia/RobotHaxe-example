package ;

import com.zedia.testrobothaxe.RobotContext;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.Lib;
import nme.display.Sprite;
import robothaxe.mvcs.Context;
import com.zedia.robothaxe.BaseView;


class Main extends Sprite{
	static private var _context:RobotContext;
	
	
	static public function main() {
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// entry point
		
		_context = new RobotContext(new BaseView(stage));
	}
}