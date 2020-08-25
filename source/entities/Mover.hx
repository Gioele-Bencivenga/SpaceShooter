package entities;

import flixel.tweens.FlxTween;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import echo.Body;
import hxmath.math.Vector2;
import flixel.FlxSprite;

using utilities.FlxEcho;

class Mover extends FlxSprite {
	/// CONSTANTS
	public static inline final MAX_VELOCITY = 500;
	public static inline final MAX_ROTATIONAL_VELOCITY = 1500;

	/// CONTROL FLAGS
	var canMove:Bool = false;

	public var direction(default, null):FlxVector;

	/// MOVEMENT
	var maxThrust:Int;
	var rotationalThrust:Int;

	/// BODY
	public var body(default, null):Body;

	public function new() {
		super();
	}

	public function init(_x:Float, _y:Float, _width:Int, _height:Int, _color:FlxColor, _canMove = true) {
		width = _width; // setting the FlxObject's properties is needed unless you specify the body's dimensions when creating it
		height = _height;

		/// GRAPHIC
		makeGraphic(_width, _height, _color);

		/// BODY
		this.add_body({mass: 1});
		body = this.get_body();

		/// MOVEMENT
		canMove = _canMove;
		maxThrust = 400;
		rotationalThrust = 500;
		direction = FlxVector.get(1, 1);
		body.max_velocity_length = MAX_VELOCITY;
		body.max_rotational_velocity = MAX_ROTATIONAL_VELOCITY;
		body.rotational_drag = 20;

		/// POSITION
		body.x = _x;
		body.y = _y;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		handleMovement();
	}

	function handleMovement() {
		if (canMove) {
			var rotationVect = FlxVector.get(1, 1);
			rotationVect.degrees = body.rotation;

			// should we rotate left or right towards the mouse?
			if (rotationVect.crossProductLength(direction) > 0) {
				body.rotational_velocity = (rotationalThrust / 4);
			} else if (rotationVect.crossProductLength(direction) < 0) {
				body.rotational_velocity = -(rotationalThrust / 4);
			} else {
				body.rotational_velocity = 0;
			}

			// trying to make the mover only move towards his front, then rotate following the mouse
			var actualDir = Vector2.fromPolar((Math.PI / 180) * rotationVect.degrees, direction.length * 2);
			body.acceleration.set(actualDir.x, actualDir.y);
		}
	}
}
