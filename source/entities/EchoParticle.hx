package entities;

import utilities.Particle;

using utilities.FlxEcho;

/**
 * Particle class inspired by FlxParticle with added Echo body and related logic
 */
class EchoParticle extends Particle {
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
	public var percent(default, null):Float = 0;

	public function new() {
		super();

		this.add_body();
		this.get_body().gravity_scale = 0;
	}

	override function fire(options:FireOptions) {
		super.fire(options);

		if (options.position != null)
			this.get_body().set_position(options.position.x, options.position.y);

		if (options.acceleration != null)
			this.get_body().acceleration.set(options.acceleration.x, options.acceleration.y);

		if (options.velocity != null)
			this.get_body().velocity.set(options.velocity.x, options.velocity.y);

		if (options.lifespan != null)
			lifespan = options.lifespan;
	}

	override function update(elapsed:Float) {
		if (age < lifespan)
			age += elapsed;

		if (age >= lifespan && lifespan != 0) {
			kill();
		}

		super.update(elapsed);
	}

	override function reset(X:Float, Y:Float) {
		super.reset(X, Y);
		age = 0;

		// visible = true; // will I need this? maybe, so it's here just in case
	}
}
