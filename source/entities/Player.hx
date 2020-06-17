package entities;

import flixel.ui.FlxVirtualPad;
import flixel.util.FlxColor;
import flixel.FlxG;

class Player extends Mover {
	#if mobile
	public var virtualPad:FlxVirtualPad;
	#end

	public function new() {
		super();

		#if mobile
		virtualPad = new FlxVirtualPad(FULL, NONE);
		#end
	}

	override function init(_x:Float, _y:Float, _width:Int, _height:Int, _color:FlxColor, _canMove = true) {
		super.init(_x, _y, _width, _height, _color);
	}

	override function update(elapsed:Float) {
		getInput();

		super.update(elapsed);
	}

	function getInput() {
		#if FLX_KEYBOARD
		upPressed = FlxG.keys.anyPressed([UP, W]);
		downPressed = FlxG.keys.anyPressed([DOWN, S]);
		leftPressed = FlxG.keys.anyPressed([LEFT, A]);
		rightPressed = FlxG.keys.anyPressed([RIGHT, D]);
		#else
		upPressed = upPressed || virtualPad.buttonUp.pressed;
		downPressed = downPressed || virtualPad.buttonDown.pressed;
		leftPressed = leftPressed || virtualPad.buttonLeft.pressed;
		rightPressed = rightPressed || virtualPad.buttonRight.pressed;
		#end
	}
}
