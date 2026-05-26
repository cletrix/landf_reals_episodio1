package;

import go.BaseSprite;
import go.Image;

class PageBackground extends BaseSprite {
	static inline var PATH = "assets/images/background.png";

	var image:Image;

	public function new() {
		super();
		mouseEnabled = false;
		mouseChildren = false;

		image = new Image(PATH);
		addChild(image);
	}
}
