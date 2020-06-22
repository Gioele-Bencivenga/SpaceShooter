package entities;

import utilities.FlxEcho;
import echo.World;
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

	var offsetX:Int;
	var offsetY:Int;
	var offsetsUpdater:FlxTimer;

	public function new(_minDistanceFromPoint:Float, _maxDistanceFromPoint:Float, _followSpeed:Float) {
		super();

		minDistanceFromPoint = _minDistanceFromPoint;
		maxDistanceFromPoint = _maxDistanceFromPoint;
		followSpeed = _followSpeed;
	}

	override function init(_x:Float, _y:Float, _width:Int, _height:Int, _color:FlxColor, _canMove = true) {
		super.init(_x, _y, _width, _height, _color);

		offsetsUpdater = new FlxTimer().start(5, function(_) {
			updateOffsets();
		}, 0);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		followParent();
	}

	public function assignParent(_parent:Mover) {
		parent = _parent;
		updateOffsets();
	}

	// I could keep this trype of follower as "Buzzer" and make it more excited tho;
	private function followParent() {
		if (parent != null) {
			var desiredPoint = parent.getMidpoint().add(0, -150);
			var distanceFromPoint = getMidpoint().distanceTo(desiredPoint);
			desiredPoint.x += offsetX;
			desiredPoint.y += offsetY;

			if (distanceFromPoint > maxDistanceFromPoint) {
				direction.set(desiredPoint.x - getMidpoint().x, desiredPoint.y - getMidpoint().y);
			} else if (distanceFromPoint < minDistanceFromPoint) {
				direction.set(desiredPoint.x - getMidpoint().x, desiredPoint.y - getMidpoint().y);
				direction.rotateByDegrees(180); // rotate by 180 desgrees the vector so it points opposite
			}

			direction.length = distanceFromPoint + followSpeed;
			// if direction points in a cone above us then we go faster to counteract gravity
			if (direction.degrees >= 20 && direction.degrees <= 160) {
				direction.length *= 3;
			}
			if (direction.degrees >= -45 && direction.degrees <= -135) {
				direction.rotateByDegrees(180);
				direction.length /= 2;
			}

			body.acceleration.multiplyWith(distanceFromPoint / 20);
		}
	}

	private function updateOffsets() {
		if (parent != null) {
			offsetX = FlxG.random.int(-30, 30);
			offsetY = FlxG.random.int(-20, 30);
		}
	}
}
