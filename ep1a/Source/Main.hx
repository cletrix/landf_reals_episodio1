package;

import openfl.display.Sprite;
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

		game = new Game();

		resLabel = new Label("", "fonts/Jellee.ttf", 20, 0, 0, 200, 30);
		resLabel.fontColor = 0xFFFFFF;
		resLabel.textAlign = "RIGHT";

		addChild(game);
		addChild(resLabel);

		onResize(null);

		#if html5
		js.Browser.window.addEventListener("resize", function(_) onResize(null));
		#else
		stage.addEventListener(Event.RESIZE, onResize);
		#end
	}

	private function getRealWidth():Int {
		#if html5
		return js.Browser.window.innerWidth;
		#else
		return stage.stageWidth;
		#end
	}

	private function getRealHeight():Int {
		#if html5
		return js.Browser.window.innerHeight;
		#else
		return stage.stageHeight;
		#end
	}

	private function onResize(e:Event):Void {
		var rw = getRealWidth();
		var rh = getRealHeight();
		var w = stage.stageWidth;
		var h = stage.stageHeight;

		trace('stage: ${stage.stageWidth}x${stage.stageHeight} | real: ${rw}x${rh} | ratio: ${Math.round(rw / rh * 100) / 100}');

		game.resize(w, h, rw, rh);
		game.position(0, 0);

		resLabel.text = '${rw}x${rh}';
		resLabel.x = w - resLabel.width - 10;
		resLabel.y = 10;
	}
}
