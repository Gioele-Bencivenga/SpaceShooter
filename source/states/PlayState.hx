package states;

import echo.World;
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
	public static var movers:FlxGroup;
	public static var followers:FlxGroup;
	public static var terrainTiles:FlxGroup;

	var player:Player;

	var debugLine:VectorDebugLine;
	var follDebugLine:VectorDebugLine;

	override public function create() {
		/// GROUPS
		terrainTiles = new FlxGroup();
		add(terrainTiles);
		movers = new FlxGroup();
		add(movers);
		followers = new FlxGroup();
		add(followers);

		/// TILEMAP AND LAYERS
		map = new FlxOgmo3Loader('assets/data/ogmo/The-Pit.ogmo', 'assets/data/ogmo/firstMap.json');
		collisionLayer = map.loadTilemap('assets/data/tilesets/tiles.png', 'collisions');
		add(collisionLayer);

		// First thing we want to do before creating any physics objects is init() our Echo world.
		FlxEcho.init({
			width: collisionLayer.widthInTiles, // Make the size of your Echo world equal the size of your play field
			height: collisionLayer.heightInTiles,
			gravity_y: 200
		});

		var tilemap = TileMap.generate(collisionLayer.getData(/*true*/), 16, 16, collisionLayer.widthInTiles, collisionLayer.heightInTiles, 0, 0, 2);
		for (t in tilemap) {
			var tile = new Tile();
			var tileBounds = t.bounds(); // since the generated bodies are optimized we need to pass their actual width and heigh
			tile.init(t.x, t.y, tileBounds.width, tileBounds.height);
			tile.set_body(t); // set the tile's body to the generated body
			tile.add_to_group(terrainTiles);
			tileBounds.put(); // don't know what this does but thanks @austineast
		}

		player = new Player();
		player.init(16, 16, 35, 10, FlxColor.ORANGE);
		player.add_to_group(movers);

		for (i in 0...6) {
			var follower = new Follower(FlxG.random.int(20, 200), FlxG.random.int(100, 250), FlxG.random.int(10, 200));
			follower.init(player.body.x - 5, player.body.y - 5, 18, 8, FlxColor.GREEN);
			follower.add_to_group(followers);
			follower.assignParent(player);
		}

		var follower = new Follower(150, 200, 50);
		follower.init(player.body.x - 5, player.body.y - 5, 18, 8, FlxColor.YELLOW);
		follower.add_to_group(followers);
		follower.assignParent(player);

		/// COLLISIONS
		followers.listen(terrainTiles);
		movers.listen(terrainTiles);
		movers.listen(movers);

		/// HUD
		var hud = new HUD(player);
		add(hud);

		/// CAMERA SETUP
		FlxG.camera.follow(player, FlxCameraFollowStyle.LOCKON);

		/// DEBUG
		debugLine = new VectorDebugLine(player, FlxColor.RED);
		add(debugLine);
		follDebugLine = new VectorDebugLine(follower, FlxColor.GRAY);
		add(follDebugLine);

		super.create();
	}

	override public function update(elapsed:Float) {
		FlxEcho.update(elapsed); // Make sure to call `FlxEcho.update()` before `super.update()`!
		super.update(elapsed);
	}
}
