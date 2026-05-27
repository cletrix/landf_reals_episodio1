package;

import openfl.events.Event;
import go.BaseSprite;
import go.Image;

class PageBackground extends BaseSprite {
	var image:Image;

	public function new(path:String) {
		super();
		mouseEnabled = false;
		mouseChildren = false;

		image = new Image(path);
		addChild(image);

		if (stage != null)
			onFill();
		else
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}

	function onAdded(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		onFill();
	}

	function onFill():Void {
		image.fillArea(stage.stageWidth, stage.stageHeight);
	}

	public function resize(w:Float, h:Float):Void {
		image.fillArea(w, h);
	}
}
