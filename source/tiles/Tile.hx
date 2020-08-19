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
	}

	public function init(_x:Float, _y:Float, _width:Float, _height:Float) {
		width = _width; // setting the FlxObject's properties is needed unless you specify the body's dimensions when creating it
		height = _height;

		/// GRAPHIC
		makeGraphic(Std.int(_width), Std.int(_height), FlxColor.WHITE);

		/// BODY
		this.add_body({mass: 0});
		body = this.get_body();

		/// POSITION
		body.x = _x;
		body.y = _y;
	}
}
