package;

import go.BaseSprite;

class Game extends BaseSprite {
	var bg:Background;
	// var logo:Logo;

	public function new() {
		super();
		bg = new Background();
		// logo = new Logo();
		addChild(bg);
		// addChild(logo);
	}

	public function resize(w:Float, h:Float):Void {
		bg.resize(w, h);
		// logo.position_in_center(w / 2, h / 2);
	}
}
