package entities;

import flixel.tweens.FlxTween;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import echo.Body;
import hxmath.math.Vector2;
import flixel.FlxSprite;

using utilities.FlxEcho;

class Mover extends FlxSprite {
	/// CONTROL FLAGS
	var canMove:Bool = false;
	var direction:FlxVector;

	/// MOVEMENT
	var thrust:Int;
	var rotationalThrust:Int;

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
		rotationalThrust = 150;
		direction = new FlxVector();
		body.max_velocity_length = 1000;
		body.max_rotational_velocity = 500;
		body.rotational_drag = 150;

		/// POSITION
		body.x = _x;
		body.y = _y;
	}

	override function update(elapsed:Float) {
		handleMovement();

		super.update(elapsed);
	}

	function handleMovement() {
		if (canMove) {
			var rotationVect = FlxVector.get(1, 1);
			rotationVect.degrees = body.rotation;
			if (rotationVect.crossProductLength(direction) > 0) {
				body.rotational_velocity = rotationalThrust;
			} else if (rotationVect.crossProductLength(direction) < 0) {
				body.rotational_velocity = -rotationalThrust;
			} else {
				body.rotational_velocity = 0;
			}
		}
	}
}
