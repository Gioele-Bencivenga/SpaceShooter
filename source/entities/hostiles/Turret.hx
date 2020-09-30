package entities.hostiles;

import flixel.util.FlxColor;

class Turret extends Fixed {
	var target:Player;

	/**
	 * Every `frequency` seconds the turret shoots a missile if it has acquired a target.
	 */
	var frequency:Float;

	public function new(_frequency:Float) {
		super();

		frequency = _frequency;
	}

	override function init(_x:Float, _y:Float, _radius:Int, _color:FlxColor) {
		super.init(_x, _y, _radius, _color);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}
}
