package;

import go.BaseSprite;
import go.Image;
import openfl.filters.BlurFilter;

class PageBackground extends BaseSprite {
	static inline var PATH = "assets/images/background.jpg";
	static inline var BLUR = 12.0;

	var image:Image;

	public function new() {
		super();
		mouseEnabled = false;
		mouseChildren = false;

		image = new Image(PATH);
		image.filters = [new BlurFilter(BLUR, BLUR, 3)];
		addChild(image);
	}
}
