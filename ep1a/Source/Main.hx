package;

import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import go.Label;

class Main extends Sprite {
	var game:Game;
	var resLabel:Label;

	public function new() {
		super();
		if (stage != null)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(e:Event = null):Void {
		if (e != null)
			removeEventListener(Event.ADDED_TO_STAGE, init);

		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.color = 0x022F13;

		game = new Game();

		resLabel = new Label("", "fonts/Jellee.ttf", 20, 0, 0, 200, 30);
		resLabel.fontColor = 0xFFFFFF;
		resLabel.textAlign = "RIGHT";

		addChild(game);
		addChild(resLabel);

		stage.addEventListener(Event.RESIZE, onResize);
		#if html5
		js.Browser.window.addEventListener("resize", function(_) {
			onResize(null);
		});
		#end

		onResize(null);
	}

	private function getW():Int {
		#if html5
		return js.Browser.window.innerWidth;
		#else
		return stage.stageWidth;
		#end
	}

	private function getH():Int {
		#if html5
		return js.Browser.window.innerHeight;
		#else
		return stage.stageHeight;
		#end
	}

	private function onResize(e:Event):Void {
		var w = getW();
		var h = getH();

		var landscape = w >= h;
		var effW:Float = landscape ? 1280 : 720;
		var effH:Float = landscape ? 720 : 1280;
		var s = Math.min(w / effW, h / effH);

		trace('window: ${w}x${h} | game: ${effW}x${effH} | scale: ${Math.round(s * 100) / 100} | ${landscape ? "landscape" : "portrait"}');

		game.resize(effW, effH);
		game.uniformScale(s);
		game.position_in_center(w / 2, h / 2);

		resLabel.text = '${w}x${h}';
		resLabel.x = w - resLabel.width - 10;
		resLabel.y = 10;
	}
}
