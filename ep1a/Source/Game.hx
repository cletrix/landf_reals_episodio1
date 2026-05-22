package;

import go.BaseSprite;
import go.Label;

class Game extends BaseSprite {
	var bg:Background;
	var logo:Logo;
	var resLabel:Label;

	public function new() {
		super();
		bg = new Background();
		logo = new Logo();
		resLabel = new Label("", "fonts/Jellee.ttf", 20, 0, 0, 200, 30);
		resLabel.fontColor = 0xFFFFFF;
		resLabel.textAlign = "RIGHT";
		addChild(bg);
		addChild(logo);
		addChild(resLabel);
	}

	public function resize(w:Float, h:Float):Void {
		bg.resize(w, h);
		logo.position_in_center(w / 2, h / 2);
		resLabel.text = '${Std.int(w)}x${Std.int(h)}';
		resLabel.x = w - resLabel.width - 10;
		resLabel.y = 10;
	}
}
