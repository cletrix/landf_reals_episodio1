package;

import go.BaseSprite;
import go.FPS;
import go.Label;

class Debug extends BaseSprite {
	var fps:FPS;
	var verLabel:Label;
	var resLabel:Label;
	var dprLabel:Label;

	public function new() {
		super();
		fps = new FPS();
		verLabel = new Label("v" + Control.VERSION, "fonts/Jellee.ttf", 16, 0, 0, 200, 25);
		verLabel.fontColor = 0xFFFFFF;
		verLabel.textAlign = "RIGHT";
		resLabel = new Label("", "fonts/Jellee.ttf", 20, 0, 0, 200, 30);
		resLabel.fontColor = 0xFFFFFF;
		resLabel.textAlign = "RIGHT";
		dprLabel = new Label("", "fonts/Jellee.ttf", 16, 10, 48, 100, 25);
		dprLabel.fontColor = 0xFFFFFF;
		addChild(fps);
		addChild(verLabel);
		addChild(resLabel);
		addChild(dprLabel);
	}

	public function setDpr(hiRes:Bool):Void {
		dprLabel.text = hiRes ? "img: 2x" : "img: 1x";
	}

	public function resize(w:Float, h:Float):Void {
		resLabel.text = '${Std.int(w)}x${Std.int(h)}';
		resLabel.x = w - resLabel.width - 10;
		resLabel.y = 10;
		verLabel.x = w - verLabel.width - 10;
		verLabel.y = resLabel.y + 30;
	}
}
