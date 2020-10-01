package entities;

import hxmath.math.Vector2;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import echo.Body;
import flixel.FlxSprite;

using utilities.FlxEcho;

/**
 * An entity that tries to stay fixed in place
 */
class Fixed extends Entity {
	public function new() {
		super();
	}

	override function init(_x:Float, _y:Float, _radius:Int, _color:FlxColor) {
		super.init(_x, _y, _radius, _color);

		/// STATS
		health = 20;

		/// GRAPHIC
		makeGraphic(_radius, _radius, _color);

		canMove = false;

		/// BODY
		body.clear_shapes();
		body.create_shape({
			type: RECT,
			height: _radius,
			width: _radius,
		});
		body.mass = 0;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}

	override function hurt(_damage:Float) {
		super.hurt(_damage);

		if (health <= Entity.MAX_HEALTH / 10) {
			canMove = true;
			body.mass = 1.5;
		}
	}
}
