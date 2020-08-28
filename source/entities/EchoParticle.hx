package entities;

import utilities.Particle;

using utilities.FlxEcho;

class EchoParticle extends Particle {
	public function new() {
        super();
        
        this.add_body();
	}
}
