package tiles;

import flixel.util.FlxColor;
import echo.Body;
import flixel.FlxSprite;

using echo.FlxEcho;

class Tile extends FlxSprite {
	/// BODY
	public var body(default, null):Body;

	public function new() {
		super();

		makeGraphic(1, 1, FlxColor.TRANSPARENT);
	}
}
