package entities;

import flixel.FlxSprite;
import flixel.util.helpers.FlxPointRangeBounds;
import flixel.util.helpers.FlxRange;
import flixel.util.helpers.FlxRangeBounds;
import flixel.FlxG;
import states.PlayState;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import hxmath.math.Vector2;

using utilities.FlxEcho;

/**
 * An entity that can thrust and move in a missile-like fashion in a direction opposite to the mouse.
 */
class Thruster extends Entity {
	/**
	 * Whether the Thruster is applying thrust (trying to move) or not
	 */
	var isThrusting:Bool = false;

	/**
	 * The direction from this Thruster to where we are pressing
	 */
	public var direction(default, null):FlxVector;

	/**
	 * Thrusters already thrust with the value of `direction.length`, this is thrust additional to that.
	 */
	var thrust:Int;

	/**
	 * rotational thrust that is applied when the thruster is not facing where it should
	 */
	var rotationalThrust:Int;

	public function new() {
		super();
	}

	override function init(_x:Float, _y:Float, _radius:Int, _color:FlxColor) {
		super.init(_x, _y, _radius, _color);

		/// STATS
		health = 20;

		/// MOVEMENT
		canMove = true;
		thrust = 0;
		rotationalThrust = 300;
		direction = FlxVector.get(1, 1);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (canMove) {
			handleMovement();
		} else {}
	}

	function handleMovement() {
		if (isThrusting) {
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
		} else {
			body.acceleration.set(0, 0); // we need to set acceleration to 0 when not thrusting otherwise we'll keep accelerating
		}
	}

	function shootTrail() {
		var normDir = Vector2.fromPolar((Math.PI / 180) * body.rotation, 10);
		var trailPosition = body.get_position().subtractWith(normDir);
		var randAngle = FlxG.random.int(-15, 15);

		PlayState.emitter.fire({
			position: trailPosition,
			posDriftX: new FlxRange(-0.5, 0.5),
			posDriftY: new FlxRange(-0.5, 0.5),
			color: new FlxRangeBounds(FlxColor.WHITE, FlxColor.YELLOW, FlxColor.ORANGE, FlxColor.RED),
			alpha: new FlxRangeBounds(1.0, 1.0, 0.2, 0.4),
			scale: new FlxPointRangeBounds(0, 0, 3, 3, 13, 13, 20, 20),
			amount: 2,
			lifespan: 0.4,
			lifespanDrift: 0.1,
			velocity: Vector2.fromPolar((Math.PI / 180) * (body.rotation + 180 + randAngle), 20 + direction.length / 2),
			velocityDrift: new FlxRange(-15.0, 15.0),
			rotational_velocity: new FlxRange(-500.0, 500.0),
			bodyDrag: 600,
			dragDrift: 200,
		});
	}
}
