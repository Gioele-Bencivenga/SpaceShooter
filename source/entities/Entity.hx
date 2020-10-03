package entities;

import flixel.util.FlxColor;
import echo.Body;
import flixel.FlxSprite;

using utilities.FlxEcho;

class Entity extends FlxSprite {
	/// CONSTANTS
	public static inline final MAX_HEALTH = 100;
	public static inline final MAX_VELOCITY = 200;
	public static inline final MAX_ROTATIONAL_VELOCITY = 1000;

	/**
	 * Whether the Thruster can move or not
	 */
	var canMove:Bool = false;

	/**
	 * The entity's physics body.
	 */
	public var body(default, null):Body;

	public function new() {
		super();
	}

	public function init(_x:Float, _y:Float, _radius:Int, _color:FlxColor) {
		health = 10;

		/// BODY
		this.add_body({
			shape: {
				type: CIRCLE,
				radius: _radius
			},
			rotation: -90,
			mass: 1,
			drag_length: 50,
			rotational_drag: 50,
			max_velocity_length: MAX_VELOCITY,
			max_rotational_velocity: MAX_ROTATIONAL_VELOCITY,
		});
		body = this.get_body();
		body.x = _x;
		body.y = _y;
	}
}
