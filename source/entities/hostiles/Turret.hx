package entities.hostiles;

import flixel.FlxG;
import echo.math.Vector2;
import states.PlayState;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;

using echo.FlxEcho;

/**
 * An entity that periodically shoots something when it has a target
 */
class Turret extends Fixed {
	/**
	 * The target this turret is trying to shoot down.
	 */
	var target:Entity;

	/**
	 * The radius that got used to build the body of this object.
	 */
	var radius:Float;

	/**
	 * Every `frequency` seconds the turret shoots if it has acquired a target.
	 */
	var frequency:Float;

	/**
	 * The number of bullets/missiles/whatever that gets spawned for each shot.
	 */
	var nOfShots:Int;

	var shootTimer:FlxTimer;

	public function new(_frequency:Float, _nOfShots:Int) {
		super();

		frequency = _frequency;
		nOfShots = _nOfShots;

		shootTimer = new FlxTimer();
	}

	override function init(_x:Float, _y:Float, _radius:Int, _color:FlxColor) {
		super.init(_x, _y, _radius, _color);

		radius = _radius;
		makeGraphic(_radius, _radius, _color);

		body.x += 5;
	}

	function shootMissile(_) {
		for (i in 0...nOfShots) {
			var missile = new Missile();
			missile.init(body.x + FlxG.random.int(-40, 40), body.y - radius, 3, FlxColor.RED);
			missile.assignTarget(target);
			missile.add_to_group(PlayState.entities);
			var dir = Vector2.from_radians(body.rotation + FlxG.random.int(-45, 45), 1000);
			missile.body.velocity.set(dir.x, dir.y);
			missile.body.rotational_velocity = FlxG.random.float(-Entity.MAX_ROTATIONAL_VELOCITY, Entity.MAX_ROTATIONAL_VELOCITY);
		}
	}

	/**
	 * Assigns `_target` to the turret's `target` variable, starting the `shootTimer` as well.
	 * @param _target the `target` the turret should target
	 */
	public function assignTarget(_target:Entity) {
		target = _target;
		shootTimer.start(frequency, shootMissile, 3);
	}

	/**
	 * Removes the target from the turret, also cancels the `shootTimer`.
	 */
	public function removeTarget() {
		target = null;
		shootTimer.cancel();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}
}
