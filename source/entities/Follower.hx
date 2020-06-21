package entities;

import flixel.math.FlxVector;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Follower extends Mover {
	var parent:Mover;

	var maxDistanceFromPoint:Float;
	var minDistanceFromPoint:Float;
	var followSpeed:Float;

	var desiredPoint:FlxPoint;

	var desiredPointRefresher:FlxTimer;

	public function new(_minDistanceFromPoint:Float, _maxDistanceFromPoint:Float, _followSpeed:Float) {
		super();

		minDistanceFromPoint = _minDistanceFromPoint;
		maxDistanceFromPoint = _maxDistanceFromPoint;
		followSpeed = _followSpeed;
	}

	override function init(_x:Float, _y:Float, _width:Int, _height:Int, _color:FlxColor, _canMove = true) {
		super.init(_x, _y, _width, _height, _color);

		rotationalThrust = 20;
		body.drag_length = 100;

		desiredPoint = FlxVector.get(getMidpoint().x, getMidpoint().y);
		desiredPointRefresher = new FlxTimer().start(1, function(_) {
			updateDesiredPoint;
		});
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		followParent();
	}

	public function assignParent(_parent:Mover) {
		parent = _parent;
		updateDesiredPoint();
	}

	private function followParent() {
		if (parent != null) {
			var distanceFromPoint = getMidpoint().distanceTo(parent.getMidpoint());
			if (distanceFromPoint > maxDistanceFromPoint) {
				direction.set((parent.getMidpoint().x - getMidpoint().x) + FlxG.random.int(-150, 150),
					(parent.getMidpoint().y - getMidpoint().y) + FlxG.random.int(20, -300));
				direction.length = distanceFromPoint * followSpeed * parent.direction.length / 100;

				// direction.set(getMidpoint().x, getMidpoint().y);
				// direction.subtractPoint(parent.getMidpoint());
			}
		}
	}

	private function updateDesiredPoint() {
		if (parent != null) {
			var offsetX = FlxG.random.int(-10, 10);
			var offsetY = FlxG.random.int(-5, 20);
			desiredPoint.set(parent.getMidpoint().x + offsetX, parent.getMidpoint().y + offsetY);
		} else {
			var offsetX = FlxG.random.int(-100, 100);
			var offsetY = FlxG.random.int(-50, 200);
			desiredPoint.set(getMidpoint().x + offsetX, getMidpoint().y + offsetY);
		}
	}
}
