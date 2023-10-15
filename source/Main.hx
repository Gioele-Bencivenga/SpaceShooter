package;

import flixel.util.FlxColor;
import flixel.FlxG;
import states.PlayState;
import flixel.FlxGame;
import openfl.display.Sprite;

// ads
// import extension.admob.AdMob;
// import extension.admob.GravityMode;
class Main extends Sprite {
	public function new() {
		super();
		//addChild(new FlxGame(768, 1366, PlayState, 1, 60, 60, true));
		addChild(new FlxGame(1366, 768, PlayState, 1, 60, true, true));
		addChild(new openfl.display.FPS(5, 5, FlxColor.WHITE));

		// we enable the system cursor instead of using the default since flixel's cursor is kind of laggy
		FlxG.mouse.useSystemCursor = true;
	}
}
