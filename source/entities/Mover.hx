package entities;

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

	/**
	 * Movers already thrust with the value of `direction.length`, this is thrust additional to that.
	 */
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

	public function init(_x:Float, _y:Float, _radius:Int, _color:FlxColor) {
		/// GRAPHIC
		makeGraphic(_radius, _radius, _color);

		/// TRAIL: basic trail characteristics, to be customized in subclasses
		trailColor = FlxColor.WHITE;
		trailStartScale = 5;
		trailEndScale = 15;
		trailLifeSpan = 0.3;

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

		/// MOVEMENT
		canMove = true;
		thrust = 0;
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

				var actualDir = Vector2.fromPolar((Math.PI / 180) * body.rotation, direction.length * 2 + thrust);
				body.acceleration.set(actualDir.x, actualDir.y);

				shootTrail();
			}
		} else {
			body.acceleration.set(0, 0); // we need to set acceleration to 0 when not thrusting otherwise we'll keep accelerating
		}
	}

	function shootTrail() {
		var trailPosition = body.get_position();
		var randAngle = FlxG.random.int(-10, 10);

		PlayState.emitter.fire({
			position: trailPosition,
			posDriftX: new FlxRange(-0.5, 0.5),
			posDriftY: new FlxRange(-0.5, 0.5),
			color: trailColor,
			startScale: trailStartScale,
			startScaleDrift: new FlxRange(-1.0, 1.0),
			endScale: trailEndScale,
			endScaleDrift: new FlxRange(0.0, 1),
			amount: 6,
			lifespan: trailLifeSpan,
			lifespanDrift: 0.05,
			velocity: Vector2.fromPolar((Math.PI / 180) * (body.rotation + 180 + randAngle), 300 + direction.length),
			velocityDrift: new FlxRange(-50.0, 50.0),
			rotational_velocity: new FlxRange(-500.0, 500.0)
		});
	}
}
