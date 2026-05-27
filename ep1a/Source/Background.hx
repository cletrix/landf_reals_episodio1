package;

import go.BaseSprite;
import libs.TiledBackground;

class Background extends BaseSprite {
	public var hiRes:Bool;

	var tiledBgPortrait:TiledBackground;
	var tiledBgLandscape:TiledBackground;

	static inline var MAP_COLS_PORTRAIT:Int = 20;
	static inline var MAP_ROWS_PORTRAIT:Int = 24;
	static inline var MAP_COLS_LANDSCAPE:Int = 24;
	static inline var MAP_ROWS_LANDSCAPE:Int = 20;

	public function new() {
		super();
		hiRes = Control.hiRes;

		tiledBgPortrait = new TiledBackground("assets/maps/mapScoreP.txt", "assets/images/tiles/box", MAP_COLS_PORTRAIT, MAP_ROWS_PORTRAIT);
		tiledBgPortrait.visible = false;
		addChild(tiledBgPortrait);

		tiledBgLandscape = new TiledBackground("assets/maps/mapScoreL.txt", "assets/images/tiles/box", MAP_COLS_LANDSCAPE, MAP_ROWS_LANDSCAPE);
		tiledBgLandscape.visible = false;
		addChild(tiledBgLandscape);
	}

	public function resize(w:Float, h:Float):Void {
		var mapPixelPortraitW = MAP_COLS_PORTRAIT * tiledBgPortrait.tileW;
		var mapPixelPortraitH = MAP_ROWS_PORTRAIT * tiledBgPortrait.tileH;
		var mapPixelLandscapeW = MAP_COLS_LANDSCAPE * tiledBgLandscape.tileW;
		var mapPixelLandscapeH = MAP_ROWS_LANDSCAPE * tiledBgLandscape.tileH;

		tiledBgPortrait.x = (w - mapPixelPortraitW) / 2;
		tiledBgPortrait.y = (h - mapPixelPortraitH) / 2;
		tiledBgLandscape.x = (w - mapPixelLandscapeW) / 2;
		tiledBgLandscape.y = (h - mapPixelLandscapeH) / 2;

		tiledBgPortrait.visible = !Control.isLandscape;
		tiledBgLandscape.visible = Control.isLandscape;
	}
}
