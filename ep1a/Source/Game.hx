package;

import go.BaseSprite;
import libs.TiledBackground;

class Game extends BaseSprite {
	var bg:Background;
	var logo:Logo;
	var tiledBg:TiledBackground;

	#if debug
	var debug:Debug;
	#end

	// mapScore.txt: 22 colunas × 24 linhas — mostrar o mapa inteiro
	static inline var MAP_COLS:Int = 22;
	static inline var MAP_ROWS:Int = 24;

	public function new() {
		super();

		bg = new Background();
		addChild(bg);

		// Fundo tileado com o mapa e tiles do futbingo
		tiledBg = new TiledBackground(
			"assets/maps/mapScore.txt",
			"assets/images/tiles/box",
			MAP_COLS,
			MAP_ROWS
		);
		addChild(tiledBg);

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

		// Centraliza o TiledBackground na tela
		var mapPixelW = MAP_COLS * tiledBg.tileW;
		var mapPixelH = MAP_ROWS * tiledBg.tileH;
		tiledBg.x = (w - mapPixelW) / 2;
		tiledBg.y = (h - mapPixelH) / 2;

		logo.position_in_center(w / 2, h / 2);

		#if debug
		debug.resize(w, h);
		#end
	}
}
