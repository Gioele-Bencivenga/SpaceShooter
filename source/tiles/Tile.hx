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

	public function init(_x:Float, _y:Float, _width:Int, _height:Int) {
		width = _width; // setting the FlxObject's properties is needed unless you specify the body's dimensions when creating it
		height = _height;

		/// GRAPHIC
		makeGraphic(_width, _height, FlxColor.WHITE);

		/// BODY
		this.add_body({mass: 0});
		body = this.get_body();

		/// POSITION
		body.x = _x;
		body.y = _y;
	}
}
