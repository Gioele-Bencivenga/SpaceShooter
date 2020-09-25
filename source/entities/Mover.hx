package entities;

import states.PlayState;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import echo.Body;
import hxmath.math.Vector2;
import flixel.FlxSprite;

using utilities.FlxEcho;

class Mover extends FlxSprite {
	/// CONSTANTS
	public static inline final MAX_VELOCITY = 200;
	public static inline final MAX_ROTATIONAL_VELOCITY = 500;

	/// CONTROL FLAGS

	/**
	 * Whether the mover can move or not
	 */
	var canMove:Bool = false;

	/**
	 * Whether the mover is applying thrust (trying to move) or not
	 */
	var isThrusting:Bool = false;

	/**
	 * The direction from this mover to where we are pressing
	 */
	public var direction(default, null):FlxVector;

	/// MOVEMENT
	var thrust:Int;
	var rotationalThrust:Int;

	/// BODY
	public var body(default, null):Body;

	/// TRAIL
	var trailColor:FlxColor;
	var trailStartScale:Float;
	var trailEndScale:Float;
	var trailLifeSpan:Float;

	public function new() {
		super();
	}

	public function init(_x:Float, _y:Float, _width:Int, _height:Int, _color:FlxColor) {
		width = _width; // setting the FlxObject's properties is needed unless you specify the body's dimensions when creating it
		height = _height;

		/// GRAPHIC
		makeGraphic(_width, _height, _color);

		/// TRAIL: basic trail characteristics, to be customized in subclasses
		trailColor = FlxColor.WHITE;
		trailStartScale = 5;
		trailEndScale = 10;
		trailLifeSpan = 0.3;

		/// BODY
		this.add_body({mass: 1});
		body = this.get_body();

		/// MOVEMENT
		canMove = true;
		thrust = 90;
		rotationalThrust = 300;
		direction = FlxVector.get(1, 1);
		body.max_velocity_length = MAX_VELOCITY;
		body.max_rotational_velocity = MAX_ROTATIONAL_VELOCITY;
		body.rotational_drag = 50;

		/// POSITION
		body.x = _x;
		body.y = _y;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		handleMovement();
	}

	function handleMovement() {
		if (isThrusting) {
			if (canMove) {
				var rotationVect = FlxVector.get(1, 1);
				rotationVect.degrees = body.rotation - 0; // -180 for making the player follow the mouse?

				var distanceFromTargetAngle = rotationVect.crossProductLength(direction);
				// should we rotate left or right towards the mouse?
				if (distanceFromTargetAngle > 0) {
					body.rotational_velocity = rotationalThrust / 4;
					if (distanceFromTargetAngle > 35) {
						body.rotational_velocity = rotationalThrust / 2;
						if (distanceFromTargetAngle > 80) {
							body.rotational_velocity = rotationalThrust;
						}
					}
				} else if (distanceFromTargetAngle < 0) {
					body.rotational_velocity = -rotationalThrust / 4;
					if (distanceFromTargetAngle < -35) {
						body.rotational_velocity = -rotationalThrust / 2;
						if (distanceFromTargetAngle < -80) {
							body.rotational_velocity = -rotationalThrust;
						}
					}
				} else {
					body.rotational_velocity = 0;
				}

				var actualDir = Vector2.fromPolar((Math.PI / 180) * body.rotation, direction.length + thrust);
				body.acceleration.set(actualDir.x, actualDir.y);

				shootTrail();
			}
		} else {
			body.acceleration.set(0, 0); // we need to set acceleration to 0 when not thrusting otherwise we'll keep accelerating
		}
	}

	function shootTrail() {
		PlayState.emitter.fire({
			position: body.get_position(),
			color: trailColor,
			startScale: trailStartScale,
			endScale: trailEndScale,
			util_amount: 1,
			lifespan: trailLifeSpan,
			velocity: Vector2.fromPolar((Math.PI / 180) * (body.rotation + 180), body.velocity.length / 2 + direction.length / 2)
		});
	}
}
