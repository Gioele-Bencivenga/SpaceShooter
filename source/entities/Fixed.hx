package entities;

import flixel.util.helpers.FlxPointRangeBounds;
import flixel.math.FlxRandom;
import flixel.util.helpers.FlxRange;
import flixel.util.helpers.FlxRangeBounds;
import flixel.FlxG;
import echo.data.Options.ShapeOptions;
import states.PlayState;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import echo.Body;
import hxmath.math.Vector2;
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
				offset_x: 2,
				radius: _radius,
				rotation: 50, // why doesn't this work?
			},
			rotation: -90,
			mass: 1
		});
		body = this.get_body();

		/// POSITION
		body.x = _x;
		body.y = _y;
	}
}
