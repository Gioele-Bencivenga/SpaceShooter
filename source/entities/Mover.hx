package entities;

import flixel.FlxSprite;

using utilities.FlxEcho;

class Mover extends FlxSprite {
	/// CONTROL FLAGS
	var canMove:Bool;
	var forwardPressed:Bool;
	var backwardPressed:Bool;
	var leftPressed:Bool;
	var rightPressed:Bool;

	public function new(x:Float, y:Float, w:Int, h:Int, c:Int, control:Bool = false) {
		super(x, y);
		makeGraphic(w, h, c);
	}

	override function update(elapsed:Float) {
		updateMovement();

		super.update(elapsed);
	}

	function updateMovement() {
		var body = this.get_body();

		if (canMove) {
			// opposing directions cancel each other out
			if (forwardPressed && backwardPressed)
				forwardPressed = backwardPressed = false;
			if (leftPressed && rightPressed)
				leftPressed = rightPressed = false;

			if (forwardPressed || backwardPressed || leftPressed || rightPressed) {
				directionAngle = 0;
				if (up) {
					directionAngle = -90;
					if (left)
						directionAngle -= 45;
					else if (right)
						directionAngle += 45;
					facing = FlxObject.UP;
				} else if (down) {
					directionAngle = 90;
					if (left)
						directionAngle += 45;
					else if (right)
						directionAngle -= 45;
					facing = FlxObject.DOWN;
				} else if (left) {
					directionAngle = 180;
					facing = FlxObject.LEFT;
				} else if (right) {
					directionAngle = 0;
					facing = FlxObject.RIGHT;
				}
			}
			body.velocity.x = 0;
			if (FlxG.keys.pressed.LEFT)
				body.velocity.x -= 128;
			if (FlxG.keys.pressed.RIGHT)
				body.velocity.x += 128;
			if (FlxG.keys.justPressed.UP && isTouching(FLOOR))
				body.velocity.y -= 256;
		}
	}
