package entities;

import flixel.util.helpers.FlxPointRangeBounds;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Missile extends Thruster {
	var target:Entity;

	var offsetX:Int; // actual offset on the X axis
	var minOffsetX:Int; // minimum random offset on the X axis
	var maxOffsetX:Int; // maximum random offset on the X axis
	var offsetY:Int;
	var minOffsetY:Int;
	var maxOffsetY:Int;
	var offsetsUpdater:FlxTimer; // timer that updates the offsets

	override function init(_x:Float, _y:Float, _radius:Int, _color:FlxColor) {
		super.init(_x, _y, _radius, _color);

		/// GRAPHICS
		loadGraphic("assets/images/weapons/missile/thrustStraight.png", true, 16, 26);
		// animation.add("stillStraight", [0], 5);
		animation.add("thrustStraight", [1, 2], 5);

		/// STATS
		thrust = 250;
		rotationalThrust = 150;

		/// TRAIL
		trailPosDrift = 5;
		trailScale = new FlxPointRangeBounds(1, 1, 5, 5, 7, 7, 12, 12);
		trailLifespan = 0.1;

		/// BODY
		body.clear_shapes();
		body.create_shape({
			type: RECT,
			height: _radius * 2,
			width: _radius * 3,
			offset_x: 2,
		});

		body.max_velocity_length += 10;
		body.gravity_scale = 0.5;

		minOffsetX = minOffsetY = -30;
		maxOffsetX = maxOffsetY = 30;
		offsetsUpdater = new FlxTimer().start(3, function(_) {
			updateOffsets();
		}, 0);
	}

	private function updateOffsets() {
		if (target != null) {
			offsetX = FlxG.random.int(minOffsetX, maxOffsetX);
			offsetY = FlxG.random.int(minOffsetY, maxOffsetY);
		}
	}

	public function assignTarget(_target:Entity) {
		target = _target;
		updateOffsets();
	}

	private function followTarget() {
		if (target != null) {
			isThrusting = true;
			var desiredPoint = target.getMidpoint();
			desiredPoint.x += offsetX;
			desiredPoint.y += offsetY;

			direction.set(desiredPoint.x - getMidpoint().x, desiredPoint.y - getMidpoint().y);

			direction.length = thrust;
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		followTarget();
		handleAnimations();
	}

	function handleAnimations() {
		if (isThrusting) {
			animation.play("thrustStraight");
		}
	}
}
