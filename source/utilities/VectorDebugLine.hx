package utilities;

import flixel.util.FlxColor;
import entities.Mover;
import flixel.FlxSprite;

class VectorDebugLine extends FlxSprite {
	var moverRef:Mover;

	public function new(_moverRef:Mover, _color:FlxColor) {
		super();
		moverRef = _moverRef;
		color = _color;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (moverRef.direction.length > 0) {
			makeGraphic(Std.int(moverRef.direction.length), 1, color).setPosition(moverRef.getMidpoint().x, moverRef.getMidpoint().y);
			origin.x = 0;
			angle = moverRef.direction.degrees;
		}
	}
}
