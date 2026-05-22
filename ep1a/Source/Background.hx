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

	public function new() {
		super();
		imgLand = new Image("assets/images/bg/bg-landscape.jpg");
		imgPort = new Image("assets/images/bg/bg-portrait.jpg");
		origLandW = imgLand.width;
		origLandH = imgLand.height;
		origPortW = imgPort.width;
		origPortH = imgPort.height;
		imgPort.visible = false;
		addChild(imgLand);
		addChild(imgPort);
	}

	public function resize(w:Float, h:Float, realW:Float, realH:Float):Void {
		var landscape = realW >= realH;
		imgLand.visible = landscape;
		imgPort.visible = !landscape;

		var img = landscape ? imgLand : imgPort;
		var iW = landscape ? origLandW : origPortW;
		var iH = landscape ? origLandH : origPortH;

		var s = Math.max(w / iW, h / iH);
		img.scaleX = s;
		img.scaleY = s;
		img.x = (w - iW * s) / 2;
		img.y = (h - iH * s) / 2;
	}
}
