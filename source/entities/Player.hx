package entities;

import flixel.math.FlxVector;
import flixel.util.FlxColor;
import flixel.FlxG;

using utilities.FlxEcho;

class Player extends Thruster {
	/// CONTROLS
	var pressPosition:FlxVector; // where the user is pressing on the screen

	public function new() {
		super();
	}

	override function init(_x:Float, _y:Float, _radius:Int, _color:FlxColor) {
		super.init(_x, _y, _radius, _color);

		/// BODY
		body.clear_shapes();
		body.create_shape({
			type: CIRCLE,
			sides: 5,
			radius: _radius,
			offset_x: 2,
		});
		body.mass = 1.2;

		/// GRAPHICS
		loadGraphic("assets/images/characters/ship/alien.png", true, 16, 26);
		animation.add("stillStraight", [0], 5);
		animation.add("thrustStraight", [1, 2], 5);
		animation.add("thrustSlightRight", [3, 4], 5);
		animation.add("thrustSlightLeft", [5, 6], 5);
		animation.add("thrustFullRight", [7, 8], 5);
		animation.add("thrustFullLeft", [9, 10], 5);

		pressPosition = FlxVector.get(1, 1);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		// if(canMove){ experiment with this
		handleInput();
		// }

		handleAnimations();
	}

	function handleInput() {
		direction.set(getPosition().x, getPosition().y);

		#if (desktop || web)
		if (FlxG.mouse.pressed) {
			isThrusting = true;
			pressPosition.set(FlxG.mouse.x, FlxG.mouse.y);
			direction.subtractPoint(pressPosition);
		} else {
			pressPosition.set(x, y);
			isThrusting = false;
		}
		#end
		#if mobile
		// this doesn't work properly and I don't know why
		if (FlxTouchManager.get)
			if (FlxG.touches.getFirst() != null) {
				var touchInput = FlxG.touches.getFirst();
				pressPosition.set(touchInput.getScreenPosition().x, touchInput.getScreenPosition().y);
			}
		#end
	}

	function handleAnimations() {
		if (isThrusting) {
			animation.play("thrustStraight");

			if (body.velocity.x >= 80) {
				animation.play("thrustSlightRight");

				if (body.velocity.x >= 150) {
					animation.play("thrustFullRight");
				}
			}
			if (body.velocity.x <= -80) {
				animation.play("thrustSlightLeft");

				if (body.velocity.x <= -150) {
					animation.play("thrustFullLeft");
				}
			}
		} else {
			animation.play("stillStraight");
		}
	}
}
