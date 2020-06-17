package entities;

import flixel.util.FlxColor;
import echo.Body;
import hxmath.math.Vector2;
import flixel.FlxSprite;

using utilities.FlxEcho;

class Mover extends FlxSprite {
	/// CONTROL FLAGS
	var canMove:Bool = false;
	var upPressed:Bool = false;
	var downPressed:Bool = false;
	var leftPressed:Bool = false;
	var rightPressed:Bool = false;

	/// MOVEMENT
	var thrust:Int;
	var rotThrust:Int;

	/// BODY
	public var body(default, null):Body;

	public function new() {
		super();
	}

	public function init(_x:Float, _y:Float, _width:Int, _height:Int, _color:FlxColor, _canMove = true) {
		width = _width; // setting the FlxObject's properties is needed unless you specify the body's dimnesions when creating it
		height = _height;

		/// GRAPHIC
		makeGraphic(_width, _height, _color);

		/// BODY
		this.add_body({mass: 1});
		body = this.get_body();

		/// MOVEMENT
		canMove = _canMove;
		thrust = 260;
		rotThrust = 100;
		body.max_velocity_length = 1000;
		body.max_rotational_velocity = 150;
		body.rotational_drag = 150;

		/// POSITION
		body.x = _x;
		body.y = _y;
	}

	override function update(elapsed:Float) {
		updateMovement();

		super.update(elapsed);
	}

	/**
	 * This function checks if the Mover can move, if so it checks if any of the pressed flags are true,
	 * and if so applies forces to the body.
	 *
	 * `upPressed` and `downPressed` apply acceleration
	 * while `leftPressed` and `rightPressed` apply rotational velocity.
	 */
	function updateMovement() {
		if (canMove) {
			if (upPressed && downPressed) // opposing directions cancel each other out
				upPressed = downPressed = false;
			if (leftPressed && rightPressed)
				leftPressed = rightPressed = false;

			if (upPressed || downPressed || leftPressed || rightPressed) {
				if (upPressed) {
					body.acceleration = Vector2.fromPolar(body.rotation * Math.PI / 180,
						thrust); // body.rotation is in degrees while the method expects radians, so we convert it
				}
				if (downPressed) {
					body.acceleration = Vector2.fromPolar(body.rotation * Math.PI / 180, -thrust);
				}

				if (leftPressed) {
					body.rotational_velocity = -rotThrust;
				}
				if (rightPressed) {
					body.rotational_velocity = rotThrust;
				}
			}
		}
	}
}
