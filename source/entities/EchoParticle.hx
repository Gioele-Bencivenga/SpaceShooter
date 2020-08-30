package entities;

import utilities.Particle;

using utilities.FlxEcho;

class EchoParticle extends Particle {
	public function new() {
		super();

		this.add_body();
		this.get_body().gravity_scale = 0;
	}

	override function fire(options:FireOptions) {
		super.fire(options);

		if (options.position != null) {
			this.get_body().set_position(options.position.x, options.position.y);
		}

		if (options.acceleration != null) {
			this.get_body().acceleration.set(options.acceleration.x, options.acceleration.y);
		}

		if (options.velocity != null) {
			this.get_body().velocity.set(options.velocity.x, options.velocity.y);
                }
                
                // todo: add logic to utilize FireOptions "util_" variables and others
	}
}
