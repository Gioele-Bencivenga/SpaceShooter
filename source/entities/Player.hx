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

		// loadGraphic("assets/images/characters/ship/straight.png", true, 16, 26);
		// setGraphicSize(Std.int(width), Std.int(height));
		/// TRAIL
		trailColor = FlxColor.ORANGE;
		trailStartScale = 6;
		trailEndScale = 9;
		trailLifeSpan = 0.4;

		pressPosition = FlxVector.get(1, 1);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		handleInput();
	}

	function handleInput() {
		#if FLX_KEYBOARD
		if (FlxG.mouse.pressed) {
			pressPosition.set(FlxG.mouse.x, FlxG.mouse.y);
		} else {
			pressPosition.set(x, y);
		}
		#else
		// this doesn't work properly and I don't know why
		if (FlxG.touches.getFirst() != null) {
			var touchInput = FlxG.touches.getFirst();
			pressPosition.set(touchInput.getScreenPosition().x, touchInput.getScreenPosition().y);
		}
		#end

		direction.set(getPosition().x, getPosition().y);
		direction.subtractPoint(pressPosition);
	}
}
