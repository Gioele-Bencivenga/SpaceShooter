package entities;

import flixel.util.FlxColor;
import echo.Body;
import hxmath.math.Vector2;
import flixel.FlxSprite;

using utilities.FlxEcho;

class Mover extends FlxSprite {
	/// CONTROL FLAGS
	var canMove:Bool = false;
	var forwardPressed:Bool = false;
	var backwardPressed:Bool = false;
	var leftPressed:Bool = false;
	var rightPressed:Bool = false;

	/// BODY
	public var body(default, null):Body;

	public function new() {
		super();

		this.add_body();
	}

	public function init(_x:Float, _y:Float, _width:Int, _height:Int, _color:FlxColor, _canMove = true) {
		body = this.get_body();
		body.drag_length = 5;
		body.max_rotational_velocity = 50;
		body.max_velocity_length = 200;
		x = _x;
		y = _y;
		makeGraphic(_width, _height, _color);
		canMove = _canMove;
	}

	override function update(elapsed:Float) {
		updateMovement();

		super.update(elapsed);
	}

	function updateMovement1() {
		if (canMove) {
			/*if (forwardPressed && backwardPressed) // opposing directions cancel each other out
					forwardPressed = backwardPressed = false;
				if (leftPressed && rightPressed)
					leftPressed = rightPressed = false; */

			if (forwardPressed || backwardPressed || leftPressed || rightPressed) {
				if (leftPressed) {
					body.rotation = 180;
				}
				if (rightPressed) {
					body.rotation = 0;
				}
				if (forwardPressed) {
					body.rotation = 270;
				}
				if (backwardPressed) {
					body.rotation = 90;
				}

				if (forwardPressed && leftPressed) {
					body.rotation = 225;
				}
				if (forwardPressed && rightPressed) {
					body.rotation = 315;
				}
				if (backwardPressed && leftPressed) {
					body.rotation = 135;
				}
				if (backwardPressed && rightPressed) {
					body.rotation = 45;
				}

				body.acceleration = Vector2.fromPolar(body.rotation * Math.PI / 180,
					200); // body.rotation is in degrees while the method expects radians, so we convert it
			}
		}
	}

	/**
	 * This function checks if the Mover can move, if so it checks if any of
	 * @param forwardPressed @param backwardPressed @param leftPressed or @param rightPressed
	 * are true, and if so applies forces to the body
	 */
	function updateMovement() {
		if (canMove) {
			if (forwardPressed && backwardPressed) // opposing directions cancel each other out
				forwardPressed = backwardPressed = false;
			if (leftPressed && rightPressed)
				leftPressed = rightPressed = false;

			if (forwardPressed || backwardPressed || leftPressed || rightPressed) {
				if (forwardPressed) {
					body.acceleration = Vector2.fromPolar(body.rotation * Math.PI / 180,
						100); // body.rotation is in degrees while the method expects radians, so we convert it
				}
				if (backwardPressed) {
					body.acceleration = Vector2.fromPolar(body.rotation * Math.PI / 180, -100);
				}

				if (leftPressed) {
					body.rotational_velocity = -30;
				}
				if (rightPressed) {
					body.rotational_velocity = 30;
				}
			}
		}
	}
}
