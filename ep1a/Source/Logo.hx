package;

import go.BaseSprite;
import go.Image;
import openfl.events.MouseEvent;

class Logo extends BaseSprite {
	var img:Image;

	public function new() {
		super();
		img = new Image("assets/openfl.png");
		addChild(img);
		addEventListener(MouseEvent.CLICK, onClick);
	}

	private function onClick(e:MouseEvent):Void {
		alpha = (alpha == 1.0) ? 0.1 : 1.0;
	}
}
