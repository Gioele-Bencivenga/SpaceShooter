package entities;

import flixel.util.FlxColor;
import flixel.FlxG;

class Player extends Mover {
	public function new() {
		super();
	}

	override function init(_x:Float, _y:Float, _width:Int, _height:Int, _color:FlxColor, _canMove = true) {
		super.init(_x, _y, _width, _height, _color);
	}

	override function update(elapsed:Float) {
		getInput();

		super.update(elapsed);
	}

	function getInput() {
		forwardPressed = FlxG.keys.anyPressed([UP, W]);
		backwardPressed = FlxG.keys.anyPressed([DOWN, S]);
		leftPressed = FlxG.keys.anyPressed([LEFT, A]);
		rightPressed = FlxG.keys.anyPressed([RIGHT, D]);
	}
}
