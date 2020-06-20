package entities;

import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.input.touch.FlxTouchManager;
import flixel.input.touch.FlxTouch;
import flixel.ui.FlxVirtualPad;
import flixel.util.FlxColor;
import flixel.FlxG;

class Player extends Mover {
	/// CONTROL FLAGS
	var touchPressed:Bool = false;

	var pressPosition:FlxVector;

	public function new() {
		super();
	}

	override function init(_x:Float, _y:Float, _width:Int, _height:Int, _color:FlxColor, _canMove = true) {
		pressPosition = new FlxVector();
		super.init(_x, _y, _width, _height, _color);
	}

	override function update(elapsed:Float) {
		handleInput();

		super.update(elapsed);
	}

	function handleInput() {
		#if FLX_KEYBOARD
		if (FlxG.mouse.pressed) {
			pressPosition = FlxVector.weak(FlxG.mouse.x, FlxG.mouse.y);
			direction = FlxVector.weak(getPosition().x, getPosition().y);
			direction.subtractPoint(pressPosition);
		}
		#else
		for (touch in FlxG.touches.list) {
			touchPressed = touch.justPressed;
			direction = FlxVector.weak(touch.justPressedPosition.x, touch.justPressedPosition.y);
		}
		#end
	}
}
