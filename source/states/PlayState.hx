package states;

import entities.hostiles.Turret;
import utilities.EchoEmitter;
import echo.util.TileMap;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import entities.*;
import hostiles.*;
import ui.*;
import tiles.*;
import utilities.VectorDebugLine;
import flixel.FlxState;

using utilities.FlxEcho;

class PlayState extends FlxState {
	/// TILEMAP STUFF
	var map:FlxOgmo3Loader;
	var collisionLayer:FlxTilemap; // this layer should never appear on screen, only used for collisions
	var backgroundLayer:FlxTilemap; // stuff displayed under everything else
	var decorationsLayer:FlxTilemap; // tiles that go over other tiles but don't fill the whole tile
	var foregroundLayer:FlxTilemap; // stuff displayed in front of everything else (also in front of entities)

	/// GROUPS
	public static var thrusters:FlxGroup;
	public static var fixeds:FlxGroup;
	public static var followers:FlxGroup;
	public static var terrainTiles:FlxGroup;
	public static var trailParticles:FlxGroup;

	/// EMITTERS
	public static var emitter:EchoEmitter;

	var player:Player;

	var debugLine:VectorDebugLine;
	var follDebugLine:VectorDebugLine;

	override public function create() {
		/// GROUPS
		thrusters = new FlxGroup();
		fixeds = new FlxGroup();
		followers = new FlxGroup();
		terrainTiles = new FlxGroup();
		trailParticles = new FlxGroup();

		/// TILEMAP AND LAYERS
		map = new FlxOgmo3Loader('assets/data/ogmo/The-Pit.ogmo', 'assets/data/ogmo/firstMap.json');
		collisionLayer = map.loadTilemap('assets/data/tilesets/tiles.png', 'collisions');
		add(collisionLayer);

		// Add stuff with the correct rendering order
		add(terrainTiles);
		add(trailParticles); // not working yet
		/// EMITTERS
		emitter = new EchoEmitter(() -> {
			new EchoParticle();
		});
		add(emitter);
		add(followers);
		add(fixeds);
		add(thrusters);

		// First thing we want to do before creating any physics objects is init() our Echo world.
		FlxEcho.init({
			width: collisionLayer.width, // Make the size of your Echo world equal the size of your play field
			height: collisionLayer.height,
			gravity_y: 150
		});

		var tilemap = TileMap.generate(collisionLayer.getData(/*true*/), 16, 16, collisionLayer.widthInTiles, collisionLayer.heightInTiles, 0, 0, 2);
		for (t in tilemap) {
			var tile = new Tile();
			var tileBounds = t.bounds(); // since the generated bodies are optimized we need to pass their actual width and height
			tile.set_body(t); // set the tile's body to the generated body
			tile.add_to_group(terrainTiles);
			tileBounds.put(); // put the bounds AABB back in the pool
		}

		/// ENTITIES
		map.loadEntities(loadEntity, "entities");

		var turret = new Turret(1);
		turret.init(player.x + 20, player.y + 10, 10, FlxColor.RED);
		turret.add_to_group(fixeds);

		// followers
		/*
			for (i in 0...3) {
				var follower = new Follower(FlxG.random.int(0, 30));
				follower.init(player.body.x - 5, player.body.y - 5, 5, FlxColor.BROWN);
				follower.add_to_group(followers);
				follower.assignParent(player);
			}
		 */

		// var follower = new Follower(10);
		// follower.init(player.body.x - 5, player.body.y - 5, 7, 7, FlxColor.YELLOW);
		// follower.add_to_group(followers);
		// follower.assignParent(player);

		// missiles
		for (i in 0...3) {
			var missile = new Missile();
			missile.init(player.body.x + 20, player.body.y + 10, 5, FlxColor.RED);
			missile.assignTarget(player);
			missile.add_to_group(thrusters);
		}

		/// COLLISIONS
		// followers.listen(terrainTiles);
		thrusters.listen(terrainTiles);
		thrusters.listen(thrusters);
		// trailParticles.listen(terrainTiles); // gives the error "Unable to get property 'length' of undefined or null reference"
		// emitter.listen(terrainTiles); // gives the error "Unable to get property 'length' of undefined or null reference"

		/// HUD
		var hud = new HUD(player);
		add(hud);

		/// CAMERA SETUP
		FlxG.camera.follow(player, FlxCameraFollowStyle.LOCKON);
		FlxG.camera.zoom = 2;

		/// DEBUG
		// follDebugLine = new VectorDebugLine(follower, FlxColor.GRAY);
		// add(follDebugLine);

		super.create();
	}

	function loadEntity(entity:EntityData) {
		switch (entity.name) {
			case "player":
				player = new Player();
				player.init(entity.x, entity.y, 7, FlxColor.CYAN);
				player.add_to_group(thrusters);
		}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
