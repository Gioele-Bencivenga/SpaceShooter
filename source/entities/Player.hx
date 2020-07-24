package entities;

import flixel.math.FlxMath;
import hxmath.math.Vector2;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.input.touch.FlxTouchManager;
import flixel.input.touch.FlxTouch;
import flixel.ui.FlxVirtualPad;
import flixel.util.FlxColor;
import flixel.FlxG;

class Player extends Mover {
	/// CONTROL FLAGS
	var pressPosition:FlxVector;

	public function new() {
		super();
	}

	override function init(_x:Float, _y:Float, _width:Int, _height:Int, _color:FlxColor, _canMove = true) {
		super.init(_x, _y, _width, _height, _color);

		// loadGraphic("assets/images/characters/ship/straight.png", true, 16, 26);
		// setGraphicSize(Std.int(width), Std.int(height));

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
