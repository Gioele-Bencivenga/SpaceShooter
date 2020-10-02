package states;

import flixel.util.FlxCollision;
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
	public static var entities:FlxGroup;
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
		entities = new FlxGroup();
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
		add(entities);

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

		var turret = new Turret(2, 1);
		turret.init(player.body.x - 20, player.body.y - 5, 20, FlxColor.YELLOW);
		turret.add_to_group(entities);
		turret.assignTarget(player);

		/// COLLISIONS
		entities.listen(terrainTiles);
		entities.listen(entities);
		emitter.listen(terrainTiles);
		emitter.listen(entities);

		/// HUD
		var hud = new HUD(player);
		add(hud);

		/// CAMERA SETUP
		FlxG.camera.follow(player, FlxCameraFollowStyle.LOCKON);
		FlxG.camera.zoom = 2;

		super.create();
	}

	function loadEntity(entity:EntityData) {
		switch (entity.name) {
			case "player":
				player = new Player();
				player.init(entity.x, entity.y, 6, FlxColor.CYAN);
				player.add_to_group(entities);
		}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
