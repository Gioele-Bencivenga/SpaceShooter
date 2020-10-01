package entities;

import flixel.math.FlxVector;
import hxmath.math.Vector2;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.util.FlxColor;

class Follower extends Thruster {
	var parent:Thruster;

	var maxDistanceFromPoint:Float;

	var offsetX:Int; // actual offset on the X axis
	var minOffsetX:Int; // minimum random offset on the X axis
	var maxOffsetX:Int; // maximum random offset on the X axis
	var offsetY:Int;
	var minOffsetY:Int;
	var maxOffsetY:Int;
	var offsetsUpdater:FlxTimer; // timer that updates the offsets

	public function new(_maxDistanceFromPoint:Float) {
		super();

		maxDistanceFromPoint = _maxDistanceFromPoint;
	}

	override function init(_x:Float, _y:Float, _radius:Int, _color:FlxColor) {
		super.init(_x, _y, _radius, _color);

		minOffsetX = minOffsetY = -150;
		maxOffsetX = maxOffsetY = 150;
		offsetsUpdater = new FlxTimer().start(5, function(_) {
			updateOffsets();
		}, 0);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		followParent();
	}

	public function assignParent(_parent:Thruster) {
		parent = _parent;
		updateOffsets();
	}

	private function followParent() {
		if (parent != null) {
			var desiredPoint = parent.getMidpoint().add(0, -50);
			var distanceFromPoint = getMidpoint().distanceTo(desiredPoint);
			desiredPoint.x += offsetX;
			desiredPoint.y += offsetY;

			direction = FlxVector.weak(desiredPoint.x - getMidpoint().x, desiredPoint.y - getMidpoint().y);
			direction.length = distanceFromPoint;

			if (distanceFromPoint > maxDistanceFromPoint) {
				body.velocity.set(direction.x, direction.y);
			} else {
				direction.length = distanceFromPoint / 3;
				body.velocity.set(direction.x, direction.y);
			}
		}
	}

	// followers don't move like Thrusters do
	override function handleMovement() {}

	private function updateOffsets() {
		if (parent != null) {
			offsetX = FlxG.random.int(minOffsetX, maxOffsetX);
			offsetY = FlxG.random.int(minOffsetY, maxOffsetY);
		}
	}
}
