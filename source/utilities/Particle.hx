package utilities;

import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * A particle class
 */
class Particle extends FlxSprite {
	/**
	 * Creates a new particle
	 */
	public function new() {
		super();

		exists = false;
	}

	/**
	 * Fires this particle with given options
	 * @param options
	 */
	public function fire(options:FireOptions) {
		reset(options.position.x, options.position.y);

		if (options.animation != null)
			animation.play(options.animation, true);
	}
}

typedef FireOptions = {
	position:FlxPoint,

	?velocity:FlxPoint,
	?acceleration:FlxPoint,
	?animation:String,
	?lifespan:Float,
	?util_amount:Float,
	?util_color:Int,
	?util_int:Int,
	?util_bool:Bool
}
