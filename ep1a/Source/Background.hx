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

	public function new() {
		super();
		landscape = createImageData("assets/images/bg/bg-landscape.jpg");
		portrait = createImageData("assets/images/bg/bg-portrait.jpg");
		currentImg = null;
	}

	function createImageData(path:String):ImageData {
		var img = new Image(path);
		return {
			image: img,
			width: img.width,
			height: img.height
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
