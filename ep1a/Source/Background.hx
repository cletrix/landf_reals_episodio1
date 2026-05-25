package;

import go.BaseSprite;
import go.Image;

typedef ImageData = {
	image:Image,
	width:Float,
	height:Float
}

class Background extends BaseSprite {
	var landscape:ImageData;
	var portrait:ImageData;
	var currentImg:Image;
	public var hiRes:Bool;

	public function new() {
		super();
		hiRes = getDevicePixelRatio() >= 2.0;

		var suffix = hiRes ? "@2x" : "";
		landscape = createImageData('assets/images/bg/bg-landscape$suffix.jpg');
		portrait = createImageData('assets/images/bg/bg-portrait$suffix.jpg');
		currentImg = null;
	}

	function getDevicePixelRatio():Float {
		#if js
		return js.Browser.window.devicePixelRatio;
		#else
		return 1.0;
		#end
	}

	function createImageData(path:String):ImageData {
		var img = new Image(path);
		if (hiRes) {
			img.scaleX = 0.5;
			img.scaleY = 0.5;
		}
		return {
			image: img,
			width: img.width * (hiRes ? 0.5 : 1.0),
			height: img.height * (hiRes ? 0.5 : 1.0)
		};
	}

	public function resize(w:Float, h:Float):Void {
		var isLandscape = w >= h;
		var data = isLandscape ? landscape : portrait;
		var img = data.image;

		if (img != currentImg) {
			if (currentImg != null)
				removeChild(currentImg);
			addChild(img);
			currentImg = img;
		}
	}
}
