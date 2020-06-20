package utilities;

import flixel.util.FlxColor;
import entities.Player;
import flixel.FlxSprite;

class VectorDebugLine extends FlxSprite {
	var playerRef:Player;

	public function new(_playerRef:Player) {
		super();
		playerRef = _playerRef;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
        makeGraphic(2, Std.int(playerRef.direction.length), FlxColor.RED).setPosition(playerRef.getMidpoint().x, playerRef.getMidpoint().y);
        //makeGraphic(Std.int(playerRef.direction.length), 2, FlxColor.RED).setPosition(playerRef.getMidpoint().x, playerRef.getMidpoint().y);
        angle = playerRef.direction.degrees;

        // feel like I'm close and missing the last step to get it working
    }
}
