package utilities;

import flixel.util.FlxColor;
import entities.Thruster;
import flixel.FlxSprite;

class VectorDebugLine extends FlxSprite {
	var ThrusterRef:Thruster;

	public function new(_ThrusterRef:Thruster, _color:FlxColor) {
		super();
		ThrusterRef = _ThrusterRef;
		color = _color;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (ThrusterRef.direction.length > 0) {
			makeGraphic(Std.int(ThrusterRef.direction.length), 1, color).setPosition(ThrusterRef.getMidpoint().x, ThrusterRef.getMidpoint().y);
			origin.x = 0;
			angle = ThrusterRef.direction.degrees;
		}
	}
}
