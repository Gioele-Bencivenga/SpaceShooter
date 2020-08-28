package utilities;

import utilities.Particle.FireOptions;
import states.PlayState;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;

using utilities.FlxEcho;

/**
 * A particle emitter class.
 *
 * Modified to work with Echo physics following @austineast's directions
 *
 * Re-implementation of zerolib's ParticleEmitter.hx for HaxeFlixel, without zerolib by @austineast
 * https://gist.github.com/AustinEast/97e23e8f157fc43e451a24107a886c65
 *
 * Originally written for zerolib by @01010111
 * https://github.com/01010111/zerolib-flixel/blob/master/zero/flixel/ec/ParticleEmitter.hx
 */
class EchoEmitter extends FlxTypedGroup<Particle> {
	var new_particle:Void->Particle;

	/**
	 * Creates a new particle emitter
	 * @param new_particle	a function that returns the desired Particle
	 */
	public function new(new_particle:Void->Particle) {
		super();

		this.new_particle = new_particle;
	}

	/**
	 * Fires a particle with given options. If none are available, it will create a new particle using the function passed in new()
	 * @param options
	 */
	public function fire(options:FireOptions) {
		while (getFirstAvailable() == null) {
			new_particle().add_to_group(PlayState.particles);
		}

		getFirstAvailable().fire(options);
	}
}