package utilities;

import echo.data.Options.BodyOptions;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxObject.*;
import flixel.group.FlxGroup;
import echo.Echo;
import echo.World;
import echo.Body;
import echo.data.Options.ListenerOptions;
import echo.data.Options.WorldOptions;

using hxmath.math.Vector2;
using Math;
using Std;

// courtesy of @01010111 at https://gist.github.com/01010111/3370831f78beae4aad768591a8eeabdb
class FlxEcho {
	static var groups:Map<FlxGroup, Array<Body>>;
	static var bodies:Map<FlxObject, Body>;
	static var world:World;

	/**
	 * Init the world
	 */
	public static function init(options:WorldOptions) {
		groups = [];
		bodies = [];
		world = Echo.start(options);
	}

	/**
	 * add physics body to FlxObject
	 */
	public static function add_body(object:FlxObject, ?options:BodyOptions) {
		if (options == null)
			options = {};
		if (options.x == null)
			options.x = object.x;
		if (options.y == null)
			options.y = object.y;
		if (options.shape == null)
			options.shape = {
				type: RECT,
				width: object.width,
				height: object.height,
				offset_x: object.width / 2,
				offset_y: object.height / 2
			}
		var body = new Body(options);
		bodies.set(object, body);
		world.add(body);
	}

	/**
	 * Adds FlxObject to FlxGroup, and the FlxObject's associated physics body to the FlxGroup's associated physics group
	 */
	public static function add_to_group(object:FlxObject, group:FlxGroup) {
		group.add(object);
		if (!groups.exists(group))
			groups.set(group, []);
		if (bodies.exists(object))
			groups[group].push(bodies[object]);
	}

	/**
	 * Creates a physics listener
	 */
	public static function listen(a:FlxBasic, b:FlxBasic, ?options:ListenerOptions) {
		if (options == null)
			options = {};
		var temp_stay = options.stay;
		options.stay = (a, b, c) -> {
			if (temp_stay != null)
				temp_stay(a, b, c);
			for (col in c)
				set_touching(get_object(a), [CEILING, WALL, FLOOR][col.normal.dot(Vector2.yAxis).round() + 1]);
		}
		#if ARCADE_PHYSICS
		var temp_condition = options.condition;
		options.condition = (a, b, c) -> {
			for (col in c)
				square_normal(col.normal);
			if (temp_condition != null)
				return temp_condition(a, b, c);
			return true;
		}
		#end
		world.listen(!a.is(FlxObject) ? groups[cast a] : bodies[cast a], !b.is(FlxObject) ? groups[cast b] : bodies[cast b], options);
	}

	/**
	 * Update physics and objects with physics bodies
	 */
	public static function update(elapsed:Float) {
		world.step(elapsed);
		for (object => body in bodies)
			update_body_object(object, body);
	}

	/**
	 * Get the physics body associated with a FlxObject
	 */
	public static function get_body(object:FlxObject):Body
		return bodies[object];

	/**
	 * Get the FlxObject associated with a physics body
	 */
	public static function get_object(body:Body):FlxObject {
		for (o => b in bodies)
			if (b == body)
				return o;
		return null;
	}

	static function update_body_object(object:FlxObject, body:Body) {
		object.setPosition(body.x, body.y);
		object.angle = body.rotation;
	}

	static function set_touching(object:FlxObject, touching:Int)
		if (object.touching & touching == 0)
			object.touching += touching;

	static function square_normal(normal:Vector2) {
		var len = normal.length;
		var dot_x = normal.dot(Vector2.xAxis);
		var dot_y = normal.dot(Vector2.yAxis);
		if (dot_x.abs() > dot_y.abs())
			dot_x > 0 ? normal.set(1, 0) : normal.set(-1, 0);
		else
			dot_y > 0 ? normal.set(0, 1) : normal.set(0, -1);
		normal.normalizeTo(len);
	}
}
