package entities;

import echo.Line;
import flixel.util.FlxTimer;
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
	 * Rotational thrust that is applied when the thruster is not facing according to player input.
	 */
	var rotationalThrust:Int;

	/**
	 * The number of raycasts we want to be distributed in a circle around this thruster.
	 */
	var raycastCount:Int;

	/**
	 * The length of the raycasts we shoot from this thruster.
	 */
	var raycastLength:Int;

	var trailPosition:Vector2;
	var trailPosDrift:Float;
	var trailScale:FlxPointRangeBounds;
	var trailLifespan:Float;
	var trailLifespanDrift:Float;

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

		/// TRAIL
		trailPosDrift = 4;
		trailScale = new FlxPointRangeBounds(4, 4, 5, 5, 17, 17, 20, 20);
		trailLifespan = 0.2;

		/// RAYCASTS
		raycastCount = 100;
		raycastLength = 50;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (canMove) {
			handleMovement();
		} else {}

		var line = Line.get();
		for (i in 0...raycastCount) {
			line.set_from_vector(body.get_position(), 360 * (i / raycastCount), raycastLength);
			var result = line.linecast(PlayState.terrainTiles.get_group_bodies());
			if (result != null) {
				trace("collided!!!");
			}
		}
		line.put();
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
		var normDir = Vector2.fromPolar((Math.PI / 180) * body.rotation, 9); // raius is far downwards from the body we spawn the particles
		trailPosition = body.get_position().subtractWith(normDir);
		var randAngle = FlxG.random.int(-15, 15);

		PlayState.emitter.fire({
			position: trailPosition,
			posDriftX: new FlxRange(-trailPosDrift, trailPosDrift),
			posDriftY: new FlxRange(-trailPosDrift, trailPosDrift),
			color: new FlxRangeBounds(FlxColor.WHITE, FlxColor.YELLOW, FlxColor.ORANGE, FlxColor.RED),
			alpha: new FlxRangeBounds(1.0, 1.0, 0.5, 0.7),
			scale: trailScale,
			amount: 1,
			lifespan: trailLifespan,
			lifespanDrift: trailLifespanDrift,
			velocity: Vector2.fromPolar((Math.PI / 180) * (body.rotation + 180 + randAngle), 100 + direction.length / 2),
			velocityDrift: new FlxRange(-30.0, 30.0),
			rotational_velocity: new FlxRange(-500.0, 500.0),
			bodyDrag: 600,
			dragDrift: 200,
		});
	}
}
