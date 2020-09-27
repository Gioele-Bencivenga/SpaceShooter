package entities;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Missile extends Mover {
	var target:Mover;

	var offsetX:Int; // actual offset on the X axis
	var minOffsetX:Int; // minimum random offset on the X axis
	var maxOffsetX:Int; // maximum random offset on the X axis
	var offsetY:Int;
	var minOffsetY:Int;
	var maxOffsetY:Int;
	var offsetsUpdater:FlxTimer; // timer that updates the offsets

	override function init(_x:Float, _y:Float, _radius:Int, _color:FlxColor) {
		super.init(_x, _y, _radius, _color);

		///TRAIL
		trailColor = FlxColor.RED;
		trailStartScale = 1;
		trailEndScale = 3;
		trailLifeSpan = 0.1;

		body.max_velocity_length += 30;

		thrust = 250;
		rotationalThrust = 150;

		body.gravity_scale = 0.5;

		minOffsetX = minOffsetY = -40;
		maxOffsetX = maxOffsetY = 40;
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

	public function assignTarget(_target:Mover) {
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
	}
}
