package tools;

class Screen {
	public static function check():Void {
		#if js
		var w = js.Browser.window.screen.width;
		var h = js.Browser.window.screen.height;
		var maxDim = Math.max(w, h);
		#else
		var maxDim = 0.0;
		#end

		var hiRes = maxDim >= 1280;

		Control.suffix = hiRes ? "@2x" : "";
		Control.hiRes = hiRes;
	}

	public static function updateFormat(w:Float, h:Float):Void {
		Control.isLandscape = (w >= h);
	}
}
