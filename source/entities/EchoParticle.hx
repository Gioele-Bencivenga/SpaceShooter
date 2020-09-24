package entities;

import flixel.util.FlxDestroyUtil;
import flixel.math.FlxPoint;
import flixel.util.helpers.FlxRange;
import flixel.util.FlxColor;
import hxmath.math.Vector2;
import flixel.FlxSprite;

using utilities.FlxEcho;

/**
 * Particle class inspired by FlxParticle and modified in order to have an easier
 * integration with austineast's Echo physics library
 */
class EchoParticle extends FlxSprite {
	/**
	 * How long this particle lives before it disappears. Set to `0` to never `kill()` the particle automatically.
	 * NOTE: this is a maximum, not a minimum; the object could get recycled before its `lifespan` is up.
	 */
	public var lifespan:Float = 0;

	/**
	 * How long this particle has lived so far.
	 */
	public var age(default, null):Float = 0;

	/**
	 * What percentage progress this particle has made of its total life.
	 * Essentially just `(age / lifespan)` on a scale from `0` to `1`.
	 */
	public var lifePercent(default, null):Float = 0;

	/**
	 * The range of values for `scale` over this particle's `lifespan`.
	 */
	public var scaleRange:FlxRange<FlxPoint>;

	/**
	 * The amount of change from the previous frame.
	 * I'd like to have a more detailed explanation for this but I don't quite get it myself.
	 */
	var delta:Float = 0;

	public function new() {
		super();
		exists = false;

		this.add_body();
		this.get_body().gravity_scale = 0;

		makeGraphic(1, 1, FlxColor.WHITE);

		scaleRange = new FlxRange<FlxPoint>(FlxPoint.get(1, 1), FlxPoint.get(1, 1));
	}

	public function fire(options:FireOptions) {
		reset(options.position.x, options.position.y);

		//this.add_to_group(PlayState.trailParticles);

		if (options.position != null)
			this.get_body().set_position(options.position.x, options.position.y);

		if (options.velocity != null)
			this.get_body().velocity.set(options.velocity.x, options.velocity.y);

		if (options.acceleration != null)
			this.get_body().acceleration.set(options.acceleration.x, options.acceleration.y);

		if (options.animation != null)
			animation.play(options.animation, true);

		if (options.lifespan != null)
			lifespan = options.lifespan;

		/// SCALE STUFF
		if (options.startScale != null)
			scaleRange.start.set(options.startScale, options.startScale);
		else
			scaleRange.start.set(1, 1);

		if (options.endScale != null)
			scaleRange.end.set(options.endScale, options.endScale);
		else
			scaleRange.end.set(1, 1);
		// actually setting the particle's scale
		scale.x = scaleRange.start.x;
		scale.y = scaleRange.start.y;

		if (options.color != null)
			this.color = options.color;
	}

	override function update(elapsed:Float) {
		if (age < lifespan)
			age += elapsed;

		if (age >= lifespan && lifespan != 0) {
			kill();
		} else {
			delta = elapsed / lifespan;
			lifePercent = age / lifespan;

			if (scaleRange.active) {
				scale.x += (scaleRange.end.x - scaleRange.start.x) * delta;
				scale.y += (scaleRange.end.y - scaleRange.start.y) * delta;

				// update body here if needed
			}
		}

		super.update(elapsed);
	}

	override function reset(X:Float, Y:Float) {
		super.reset(X, Y);
		age = 0;

		// visible = true; // will I need this? maybe, so it's here just in case
	}

	override function destroy() {
		if (scaleRange != null) {
			scaleRange.start = FlxDestroyUtil.put(scaleRange.start);
			scaleRange.end = FlxDestroyUtil.put(scaleRange.end);
			scaleRange = null;
		}

		super.destroy();
	}
}

typedef FireOptions = {
	position:Vector2,

	?velocity:Vector2,
	?acceleration:Vector2,
	?animation:String,
	?lifespan:Float,
	?startScale:Float,
	?endScale:Float,
	?util_amount:Float,
	?color:Int,
	?util_int:Int,
	?util_bool:Bool
}
