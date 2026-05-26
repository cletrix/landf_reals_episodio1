package;

import go.BaseSprite;
import go.ImageButton;

class MenuButtons extends BaseSprite {
	static inline var GAP = 16.0;
	static inline var MARGIN = 32.0;

	var btnPlay:ImageButton;
	var btnInfo:ImageButton;
	var btnExit:ImageButton;

	public function new() {
		super();

		btnPlay = new ImageButton("assets/images/buttons/play/", onPlay);
		btnInfo = new ImageButton("assets/images/buttons/info/", onInfo);
		btnExit = new ImageButton("assets/images/buttons/exit/", onExit);

		addChild(btnPlay);
		addChild(btnInfo);
		addChild(btnExit);
	}

	public function resize(w:Float, h:Float):Void {
		layoutPlayInfo(w, h);
		layoutExit(w, h);
	}

	function layoutPlayInfo(w:Float, h:Float):Void {
		if (Control.isLandscape) {
			var groupH = btnPlay.height + GAP + btnInfo.height;
			var x = MARGIN;
			var y = (h - groupH) / 2;
			btnPlay.position(x, y);
			btnInfo.position(x, y + btnPlay.height + GAP);
		} else {
			var groupW = btnPlay.width + GAP + btnInfo.width;
			var groupH = Math.max(btnPlay.height, btnInfo.height);
			var x = (w - groupW) / 2;
			var y = h - MARGIN - groupH;
			btnPlay.position(x, y);
			btnInfo.position(x + btnPlay.width + GAP, y);
		}
	}

	function layoutExit(w:Float, h:Float):Void {
		btnExit.position(w - MARGIN - btnExit.width, MARGIN);
	}

	function onPlay():Void {
		trace("Play");
	}

	function onInfo():Void {
		trace("Info");
	}

	function onExit():Void {
		trace("Exit");
	}
}
