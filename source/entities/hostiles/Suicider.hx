package entities.hostiles;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import states.PlayState;

class Suicider extends Follower {
	override function update(elapsed:Float) {
		super.update(elapsed);
	}

	function acquireTarget() {
		for (mover in PlayState.movers) {
			if (FlxMath.isDistanceWithin(this, cast(mover, FlxSprite), 500)) {
				assignParent(cast(mover, Mover));
			}
		}
	}
}
