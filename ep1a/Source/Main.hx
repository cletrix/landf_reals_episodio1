package;

import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.display.Sprite;
import tools.Screen;

class Main extends Sprite {
	var game:Game;

	public function new() {
		super();
		if (stage != null)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}

	function init(e:Event = null):Void {
		if (e != null)
			removeEventListener(Event.ADDED_TO_STAGE, init);

		Screen.check();

		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.color = 0x5B0351;

		game = new Game();
		addChild(game);

		stage.addEventListener(Event.RESIZE, onResize);

		onResize(null);
	}

	function onResize(e:Event):Void {
		var w = stage.stageWidth;
		var h = stage.stageHeight;

		Screen.updateFormat(w, h);

		var landscape = Control.isLandscape;
		var effW:Float = landscape ? 1280 : 720;
		var effH:Float = landscape ? 720 : 1280;
		var s = Math.min(w / effW, h / effH);

		game.resize(effW, effH);
		game.uniformScale(s);
		game.position_in_center(w / 2, h / 2);
	}
}
