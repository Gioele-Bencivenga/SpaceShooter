package tiles;

import flixel.util.FlxColor;
import echo.Body;
import flixel.FlxSprite;

using utilities.FlxEcho;

class Tile extends FlxSprite {
	/// BODY
	public var body(default, null):Body;

	public function new() {
		super();

		this.add_body({mass: 0});
		body = this.get_body();
	}

	public function init(_x:Float, _y:Float, _width:Int, _height:Int) {
		body.x = _x;
		body.y = _y;
		makeGraphic(_width, _height, FlxColor.WHITE);
	}
}
