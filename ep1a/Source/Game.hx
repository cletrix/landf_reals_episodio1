package;

import go.BaseSprite;
import libs.TiledBackground;

class Game extends BaseSprite {
	var bg:Background;
	var logo:Logo;
	var tiledBgPortrait:TiledBackground;
	var tiledBgLandscape:TiledBackground;

	#if debug
	var debug:Debug;
	#end

	// mapScore.txt: 22 colunas × 24 linhas — mostrar o mapa inteiro
	// Portrait usar o MAP_COLS_PORTRAIT e MAP_ROWS_PORTRAIT
	static inline var MAP_COLS_PORTRAIT:Int = 20;
	static inline var MAP_ROWS_PORTRAIT:Int = 24;
	// Landscape usar o MAP_COLS_LANDSCAPE e MAP_ROWS_LANDSCAPE
	static inline var MAP_COLS_LANDSCAPE:Int = 24;
	static inline var MAP_ROWS_LANDSCAPE:Int = 20;

	public function new() {
		super();

		bg = new Background();
		addChild(bg);

		// Fundo tileado com o mapa e tiles do futbingo
		tiledBgPortrait = new TiledBackground("assets/maps/mapScoreP.txt", "assets/images/tiles/box", MAP_COLS_PORTRAIT, MAP_ROWS_PORTRAIT);
		tiledBgPortrait.visible = false;
		addChild(tiledBgPortrait);

		tiledBgLandscape = new TiledBackground("assets/maps/mapScoreL.txt", "assets/images/tiles/box", MAP_COLS_LANDSCAPE, MAP_ROWS_LANDSCAPE);
		tiledBgLandscape.visible = false;
		addChild(tiledBgLandscape);

		logo = new Logo();
		addChild(logo);

		#if debug
		debug = new Debug();
		debug.setDpr(bg.hiRes);
		addChild(debug);
		#end
	}

	public function resize(w:Float, h:Float):Void {
		bg.resize(w, h);
		var isLandscape = Control.isLandscape;
		var tiledBgPortrait = tiledBgPortrait;
		var tiledBgLandscape = tiledBgLandscape;

		// Centraliza o TiledBackground na tela
		var mapPixelPortraitW = MAP_COLS_PORTRAIT * tiledBgPortrait.tileW;
		var mapPixelPortraitH = MAP_ROWS_PORTRAIT * tiledBgPortrait.tileH;
		var mapPixelLandscapeW = MAP_COLS_LANDSCAPE * tiledBgLandscape.tileW;
		var mapPixelLandscapeH = MAP_ROWS_LANDSCAPE * tiledBgLandscape.tileH;

		tiledBgPortrait.x = (w - mapPixelPortraitW) / 2;
		tiledBgPortrait.y = (h - mapPixelPortraitH) / 2;
		tiledBgLandscape.x = (w - mapPixelLandscapeW) / 2;
		tiledBgLandscape.y = (h - mapPixelLandscapeH) / 2;

		tiledBgPortrait.visible = !isLandscape;
		tiledBgLandscape.visible = isLandscape;

		logo.position_in_center(w / 2, h / 2);

		#if debug
		debug.resize(w, h);
		#end
	}
}
