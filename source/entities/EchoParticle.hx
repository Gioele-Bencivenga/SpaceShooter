package entities;

import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.util.FlxDestroyUtil;
import flixel.math.FlxPoint;
import flixel.util.helpers.FlxRange;
import flixel.util.FlxColor;
import hxmath.math.Vector2;
import flixel.FlxSprite;
import flixel.util.helpers.FlxRangeBounds;

using utilities.FlxEcho;

/**
 * Particle class inspired by FlxParticle and modified in order to have an easier
 * integration with austineast's Echo physics library
 */
class EchoParticle extends FlxSprite {
	/**
	 * Sets `colour` range of particles launched from an emitter.
	 */
	public var colour(default, null):FlxRangeBounds<FlxColor> = new FlxRangeBounds(FlxColor.WHITE, FlxColor.WHITE);

	/**
	 * The minimum possible angle at which this particle can be fired.
	 */
	public var minAngle(default, null):Int;

	/**
	 * The maximum possible angle at which this particle can be fired.
	 */
	public var maxAngle(default, null):Int;

	/**
	 * How long this particle lives before it disappears. Set to `0` to never `kill()` the particle automatically.
	 * NOTE: this is a maximum, not a minimum; the object could get recycled before its `lifespan` is up.
	 */
	public var lifespan(default, null):Float = 0;

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
	public var scaleRange(default, null):FlxRange<FlxPoint>;

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

		// this.add_to_group(PlayState.trailParticles);

		if (options.position != null) {
			if (options.posDriftX != null) {
				options.position.x += FlxG.random.float(options.posDriftX.start, options.posDriftX.end);
			}
			if (options.posDriftY != null) {
				options.position.y += FlxG.random.float(options.posDriftY.start, options.posDriftY.end);
			}
			this.get_body().set_position(options.position.x, options.position.y);
		}

		if (options.velocity != null) {
			if (options.velocityDrift != null) {
				options.velocity.x += FlxG.random.float(options.velocityDrift.start, options.velocityDrift.end);
				options.velocity.y += FlxG.random.float(options.velocityDrift.start, options.velocityDrift.end);
			}

			this.get_body().velocity.set(options.velocity.x, options.velocity.y);
		}

		if (options.rotational_velocity != null) {
			this.get_body().rotational_velocity = FlxG.random.float(options.rotational_velocity.start, options.rotational_velocity.end);
		}

		if (options.acceleration != null)
			this.get_body().acceleration.set(options.acceleration.x, options.acceleration.y);

		if (options.bodyDrag != null) {
			if (options.dragDrift != null) {
				options.bodyDrag += FlxG.random.float(-options.dragDrift, options.dragDrift);
			}

			this.get_body().drag_length = options.bodyDrag;
		}

		if (options.lifespan != null) {
			if (options.lifespanDrift != null) {
				options.lifespan += FlxG.random.float(-options.lifespanDrift, options.lifespanDrift);
			}

			lifespan = options.lifespan;
		}

		if (options.color != null) {
			
		}

		if (options.animation != null)
			animation.play(options.animation, true);

		/// SCALE STUFF
		if (options.startScale != null) {
			if (options.startScaleDrift != null) {
				options.startScale += FlxG.random.float(options.startScaleDrift.start, options.startScaleDrift.end);
			}
			scaleRange.start.set(options.startScale, options.startScale);
		} else {
			scaleRange.start.set(1, 1);
		}

		if (options.endScale != null) {
			if (options.endScaleDrift != null) {
				options.endScale += FlxG.random.float(options.endScaleDrift.start, options.endScaleDrift.end);
			}
			scaleRange.end.set(options.endScale, options.endScale);
		} else {
			scaleRange.end.set(1, 1);
		}
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
			colour = null;
		}

		super.destroy();
	}
}

typedef FireOptions = {
	position:Vector2,
	?posDriftX:FlxRange<Float>,
	?posDriftY:FlxRange<Float>,

	?velocity:Vector2,
	?velocityDrift:FlxRange<Float>,
	?rotational_velocity:FlxRange<Float>,
	?acceleration:Vector2,
	?bodyDrag:Float,
	?minAngle:Int,
	?maxAngle:Int,
	?dragDrift:Float,
	?color:Int,
	?animation:String,
	?lifespan:Float,
	?lifespanDrift:Float,
	?startScale:Float,
	?startScaleDrift:FlxRange<Float>,
	?endScale:Float,
	?endScaleDrift:FlxRange<Float>,
	?amount:Int,
}
