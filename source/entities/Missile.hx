package entities;

import hxmath.math.Vector2;
import states.PlayState;
import flixel.math.FlxVector;
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

	override function init(_x:Float, _y:Float, _width:Int, _height:Int, _color:FlxColor) {
		super.init(_x, _y, _width, _height, _color);

		///TRAIL
		trailColor = FlxColor.RED;
		trailStartScale = 5;
		trailEndScale = 8;
		trailLifeSpan = 0.2;

		maxThrust = 250;
		rotationalThrust = 50;

		body.gravity_scale = 0.5;

		minOffsetX = minOffsetY = -70;
		maxOffsetX = maxOffsetY = 70;
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
			var desiredPoint = target.getMidpoint();
			desiredPoint.x += offsetX;
			desiredPoint.y += offsetY;

			direction.set(desiredPoint.x - getMidpoint().x, desiredPoint.y - getMidpoint().y);

			direction.length = maxThrust;
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		followTarget();
	}
}
