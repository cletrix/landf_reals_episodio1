package;

import go.BaseSprite;
import go.Image;

class Background extends BaseSprite {
	var img:Image;
	var origW:Float;
	var origH:Float;

	public function new() {
		super();
		img = new Image("assets/images/bg/bg-landscape.jpg");
		origW = img.width;
		origH = img.height;
		addChild(img);
	}

	public function resize(w:Float, h:Float):Void {
		var sx = w / origW;
		var sy = h / origH;
		var s = Math.max(sx, sy);
		img.scaleX = s;
		img.scaleY = s;
		img.x = (w - origW * s) / 2;
		img.y = (h - origH * s) / 2;
	}
}
