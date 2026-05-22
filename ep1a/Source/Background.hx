package;

import go.BaseSprite;
import go.Image;

class Background extends BaseSprite {
	var imgLand:Image;
	var imgPort:Image;
	var origLandW:Float;
	var origLandH:Float;
	var origPortW:Float;
	var origPortH:Float;
	var currentImg:Image;

	public function new() {
		super();
		imgLand = new Image("assets/images/bg/bg-landscape.jpg");
		imgPort = new Image("assets/images/bg/bg-portrait.jpg");
		origLandW = imgLand.width;
		origLandH = imgLand.height;
		origPortW = imgPort.width;
		origPortH = imgPort.height;
		currentImg = null;
	}

	public function resize(w:Float, h:Float):Void {
		var landscape = w >= h;
		var img = landscape ? imgLand : imgPort;
		var iW = landscape ? origLandW : origPortW;
		var iH = landscape ? origLandH : origPortH;

		if (img != currentImg) {
			if (currentImg != null) removeChild(currentImg);
			addChild(img);
			currentImg = img;
		}

		var s = Math.max(w / iW, h / iH);
		img.scaleX = s;
		img.scaleY = s;
		img.x = (w - iW * s) / 2;
		img.y = (h - iH * s) / 2;
	}
}
