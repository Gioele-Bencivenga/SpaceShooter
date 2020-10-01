package entities;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Missile extends Thruster {
	var target:Thruster;

	var offsetX:Int; // actual offset on the X axis
	var minOffsetX:Int; // minimum random offset on the X axis
	var maxOffsetX:Int; // maximum random offset on the X axis
	var offsetY:Int;
	var minOffsetY:Int;
	var maxOffsetY:Int;
	var offsetsUpdater:FlxTimer; // timer that updates the offsets

	override function init(_x:Float, _y:Float, _radius:Int, _color:FlxColor) {
		super.init(_x, _y, _radius, _color);

		makeGraphic(_radius, _radius * 2, _color);

		trailLifeSpan = 0.1;

		/// STATS
		thrust = 250;
		rotationalThrust = 150;

		/// BODY
		body.clear_shapes();
		body.create_shape({
			type: RECT,
			height: _radius,
			width: _radius * 2
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

	public function assignTarget(_target:Thruster) {
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
