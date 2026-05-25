package;

import go.BaseSprite;

class Game extends BaseSprite {
	var bg:Background;
	var logo:Logo;
	#if debug
	var debug:Debug;
	#end

	public function new() {
		super();

		bg = new Background();
		logo = new Logo();
		addChild(bg);
		addChild(logo);
		#if debug
		debug = new Debug();
		debug.setDpr(bg.hiRes);
		addChild(debug);
		#end
	}

	public function resize(w:Float, h:Float):Void {
		bg.resize(w, h);
		logo.position_in_center(w / 2, h / 2);
		#if debug
		debug.resize(w, h);
		#end
	}
}
