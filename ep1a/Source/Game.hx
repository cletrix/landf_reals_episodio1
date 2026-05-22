package;

import go.BaseSprite;

class Game extends BaseSprite {
	var bg:Background;
	var logo:Logo;

	public function new() {
		super();
		bg = new Background();
		logo = new Logo();
		addChild(bg);
		addChild(logo);
	}

	public function resize(w:Float, h:Float, realW:Float, realH:Float):Void {
		bg.resize(w, h, realW, realH);
		logo.position_in_center(w / 2, h / 2);
	}
}
