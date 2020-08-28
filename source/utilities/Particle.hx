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

		if (options.acceleration != null)
			acceleration.copyFrom(options.acceleration);

		if (options.velocity != null)
			velocity.copyFrom(options.velocity);

		if (options.animation != null)
			animation.play(options.animation, true);
	}
}

// no clue if I'm using this the right way, never dealt with typedefs
typedef FireOptions = {
	position:FlxPoint,

	?velocity:FlxPoint,
	?acceleration:FlxPoint,
	?animation:String,
	?util_amount:Float,
	?util_color:Int,
	?util_int:Int,
	?util_bool:Bool
}
