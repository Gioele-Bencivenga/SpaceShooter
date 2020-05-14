package states;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import entities.*;
import ui.*;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxState;

using utilities.FlxEcho;

class PlayState extends FlxState {
	var movers:FlxGroup;

	var player:Player;

	override public function create() {
		// First thing we want to do before creating any physics objects is init() our Echo world.
		FlxEcho.init({
			width: 5000,
			height: 5000
		});

		movers = new FlxGroup();
		add(movers);

		player = new Player();
		player.init(100, 100, 40, 20, FlxColor.ORANGE);
		player.add_to_group(movers);

		FlxG.camera.follow(player, FlxCameraFollowStyle.SCREEN_BY_SCREEN);

		/// HUD
		var hud = new HUD(player);
		add(hud);

		super.create();
	}

	override public function update(elapsed:Float) {
		// Make sure to call `FlxEcho.update()` before `super.update()`!
		FlxEcho.update(elapsed);
		super.update(elapsed);
	}
}
