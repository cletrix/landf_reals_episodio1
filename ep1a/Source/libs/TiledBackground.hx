package libs;

import openfl.display.Sprite;
import openfl.display.Tilemap;
import openfl.display.Tile;
import openfl.display.Tileset;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.Assets;
import StringTools;
import go.BaseSprite;

class TiledBackground extends BaseSprite {
	// Exposed read-only
	public var tilemap(default, null):Tilemap;
	public var tileset(default, null):Tileset;

	public var tileW(default, null):Int;
	public var tileH(default, null):Int;

	public var mapCols(default, null):Int;
	public var mapRows(default, null):Int;

	public var viewCols(default, null):Int;
	public var viewRows(default, null):Int;

	// Camera origin in tile coordinates
	public var viewX(default, null):Int = 0;
	public var viewY(default, null):Int = 0;

	// Full map data (indices, -1 = empty)
	var map:Array<Array<Int>>;

	public function new(mapPath:String, tilesPath:String, viewCols:Int, viewRows:Int) {
		super();

		this.viewCols = viewCols;
		this.viewRows = viewRows;

		// 1) Read and parse map from the specified path
		var mapText = Assets.getText(mapPath);
		map = parseMap(mapText);

		// Determine full map dimensions
		mapRows = map.length;
		mapCols = 0;
		for (row in map) {
			if (row.length > mapCols) {
				mapCols = row.length;
			}
		}

		// 2) Determine max tile index in map (ignoring -1)
		var maxIndex = getMaxIndex(map);
		if (maxIndex < 0) {
			// No valid tiles, nothing to draw
			return;
		}

		// Ensure tilesPath ends with "/"
		if (!StringTools.endsWith(tilesPath, "/")) {
			tilesPath += "/";
		}

		// 3) Load first tile (0.png) to get tile size
		var firstBmp:BitmapData = Assets.getBitmapData(tilesPath + "0.png");
		tileW = firstBmp.width;
		tileH = firstBmp.height;

		// 4) Build atlas: all tiles side by side horizontally
		var atlasWidth = tileW * (maxIndex + 1);
		var atlasHeight = tileH;
		var atlas = new BitmapData(atlasWidth, atlasHeight, true, 0x00000000);

		for (i in 0...maxIndex + 1) {
			var bmp:BitmapData = Assets.getBitmapData(tilesPath + i + ".png");
			var destPoint = new Point(i * tileW, 0);
			atlas.copyPixels(bmp, bmp.rect, destPoint);
		}

		// 5) Create Tileset from the atlas
		tileset = new Tileset(atlas);
		for (i in 0...maxIndex + 1) {
			var rect = new Rectangle(i * tileW, 0, tileW, tileH);
			tileset.addRect(rect);
		}

		// 6) Create Tilemap with fixed viewport size in pixels
		tilemap = new Tilemap(viewCols * tileW, viewRows * tileH, tileset);
		tilemap.smoothing = false;
		addChild(tilemap);

		this.mouseEnabled = false;
		this.mouseChildren = false;

		// 7) Initial view at (0,0)
		updateViewTiles();
	}

	// ---------------------------------------------------------------------
	// Public API
	// ---------------------------------------------------------------------

	/**
	 * Move camera to an absolute tile position (top-left of the view).
	 */
	public function setView(tileX:Int, tileY:Int):Void {
		// Clamp to map bounds
		var maxX = mapCols - viewCols;
		var maxY = mapRows - viewRows;
		if (maxX < 0)
			maxX = 0;
		if (maxY < 0)
			maxY = 0;

		if (tileX < 0)
			tileX = 0;
		if (tileY < 0)
			tileY = 0;
		if (tileX > maxX)
			tileX = maxX;
		if (tileY > maxY)
			tileY = maxY;

		if (tileX == viewX && tileY == viewY) {
			return; // no change
		}

		viewX = tileX;
		viewY = tileY;
		updateViewTiles();
	}

	/**
	 * Move camera relatively in tile units.
	 */
	public function scroll(dx:Int, dy:Int):Void {
		// dx, dy in tile units
		setView(viewX + dx, viewY + dy);
	}

	// ---------------------------------------------------------------------
	// Internal helpers
	// ---------------------------------------------------------------------

	/**
	 * Rebuild visible tiles for the current viewX/viewY.
	 * - Uses only viewCols × viewRows.
	 * - -1 in map = transparent (no tile).
	 */
	function updateViewTiles():Void {
		// Remove previous tiles
		if (tilemap.numTiles > 0) {
			tilemap.removeTiles(0, tilemap.numTiles);
		}

		for (row in 0...viewRows) {
			var mapY = viewY + row;
			if (mapY >= mapRows)
				break;

			for (col in 0...viewCols) {
				var mapX = viewX + col;
				if (mapX >= mapCols)
					break;

				var idx = map[mapY][mapX];
				if (idx < 0) {
					// -1: transparent / empty
					continue;
				}

				var x = col * tileW;
				var y = row * tileH;
				var tile = new Tile(idx, x, y);
				tilemap.addTile(tile);
			}
		}
	}

	/**
	 * Parse CSV-like map text (comma-separated) into 2D array of Int.
	 * Keeps full map.
	 */
	static function parseMap(text:String):Array<Array<Int>> {
		var result:Array<Array<Int>> = [];
		var lines = text.split("\n");

		for (line in lines) {
			var trimmed = StringTools.trim(line);
			if (trimmed == "")
				continue;

			var parts = trimmed.split(",");
			var row:Array<Int> = [];

			for (p in parts) {
				var s = StringTools.trim(p);
				if (s == "")
					continue;

				var v = Std.parseInt(s);
				if (v == null)
					v = -1; // treat invalid as empty
				row.push(v);
			}

			if (row.length > 0) {
				result.push(row);
			}
		}

		return result;
	}

	/**
	 * Finds maximum non-negative tile index in the map.
	 */
	static function getMaxIndex(map:Array<Array<Int>>):Int {
		var maxIndex = -1;
		for (row in map) {
			for (v in row) {
				if (v >= 0 && v > maxIndex) {
					maxIndex = v;
				}
			}
		}
		return maxIndex;
	}
}
