package;

import openfl.display.Sprite;
import openfl.events.Event;

class Container extends Sprite {
	public function new() {
		super();
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

	private function onResize(e:Event):Void {}
}
