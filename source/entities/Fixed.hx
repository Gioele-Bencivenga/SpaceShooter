package entities;

import flixel.util.FlxColor;
import echo.Body;
import flixel.FlxSprite;

using utilities.FlxEcho;

/**
 * An entity that stays fixed in place
 */
class Fixed extends FlxSprite {
	/// BODY
	public var body(default, null):Body;

	public function new() {
		super();
	}

	public function init(_x:Float, _y:Float, _radius:Int, _color:FlxColor) {
		/// GRAPHIC
		makeGraphic(_radius, _radius, _color);

		/// BODY
		this.add_body({
			shape: {
				type: POLYGON,
				sides: 5,
				radius: _radius
			},
			rotation: -90,
			mass: 1
		});
		body = this.get_body();

		/// POSITION
		body.x = _x;
		body.y = _y;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}
}
