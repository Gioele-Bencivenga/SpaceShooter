package entities;

import flixel.util.helpers.FlxRange;
import hxmath.math.Vector2;
import states.PlayState;
import flixel.math.FlxPoint;
import entities.EchoParticle.FireOptions;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import flixel.FlxG;
import utilities.EchoEmitter;

using utilities.FlxEcho;

class Player extends Mover {
	/// CONTROLS
	var pressPosition:FlxVector; // where the user is pressing on the screen

	public function new() {
		super();
	}

	override function init(_x:Float, _y:Float, _width:Int, _height:Int, _color:FlxColor) {
		super.init(_x, _y, _width, _height, _color);

		/// GRAPHICS
		loadGraphic("assets/images/characters/ship/alien.png", true, 16, 26);
		animation.add("stillStraight", [0], 5);
		animation.add("thrustStraight", [1, 2], 5);
		animation.add("thrustSlightRight", [3, 4], 5);
		animation.add("thrustSlightLeft", [5, 6], 5);
		animation.add("thrustFullRight", [7, 8], 5);
		animation.add("thrustFullLeft", [9, 10], 5);

		/// TRAIL
		trailColor = FlxColor.ORANGE;
		trailStartScale = 3;
		trailEndScale = 5;
		trailLifeSpan = 0.4;

		pressPosition = FlxVector.get(1, 1);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		handleInput();
		handleAnimations();
	}

	function handleInput() {
		direction.set(getPosition().x, getPosition().y);

		#if FLX_KEYBOARD
		if (FlxG.mouse.pressed) {
			isThrusting = true;
			pressPosition.set(FlxG.mouse.x, FlxG.mouse.y);
			direction.subtractPoint(pressPosition);
		} else {
			pressPosition.set(x, y);
			isThrusting = false;
		}
		#else
		// this doesn't work properly and I don't know why
		if (FlxG.touches.getFirst() != null) {
			var touchInput = FlxG.touches.getFirst();
			pressPosition.set(touchInput.getScreenPosition().x, touchInput.getScreenPosition().y);
		}
		#end
	}

	function handleAnimations() {
		if (isThrusting) {
			animation.play("thrustStraight");
		} else {
			animation.play("stillStraight");
		}
	}
}
