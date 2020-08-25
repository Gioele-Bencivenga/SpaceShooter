package entities;

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
    }

	private function followTarget() {}

    /*
	override private function followParent() {
		if (parent != null) {
			var desiredPoint = parent.getMidpoint().add(0, -50);
			var distanceFromPoint = getMidpoint().distanceTo(desiredPoint);
			desiredPoint.x += offsetX;
			desiredPoint.y += offsetY;

			if (distanceFromPoint > maxDistanceFromPoint) {
				direction.set(desiredPoint.x - getMidpoint().x, desiredPoint.y - getMidpoint().y);
			} else if (distanceFromPoint < minDistanceFromPoint) {
				direction.set(desiredPoint.x - getMidpoint().x, desiredPoint.y - getMidpoint().y);
				direction.rotateByDegrees(180); // rotate by 180 desgrees the vector so it points opposite
				direction.length += 50;
			} else {
				direction.length = 0;
			}

			if (distanceFromPoint < maxDistanceFromPoint) {
				body.velocity.clamp(10, 300);
			}

			direction.length += followSpeed;
		}
    }
    */
}
