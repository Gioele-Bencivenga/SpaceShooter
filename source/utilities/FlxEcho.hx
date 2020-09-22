package utilities;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import echo.Body;
import echo.Echo;
import echo.World;
import echo.data.Options.BodyOptions;
import echo.data.Options.ListenerOptions;
import echo.data.Options.WorldOptions;
import echo.util.AABB;
import flixel.FlxBasic;
import flixel.FlxObject.*;
import flixel.FlxObject;
import flixel.group.FlxGroup;

using hxmath.math.Vector2;

#if FLX_DEBUG
import echo.util.Debug.OpenFLDebug;
import flixel.system.ui.FlxSystemButton;
import openfl.display.BitmapData;
#end

// thanks to @austineast and @01010111 for this! from https://gist.github.com/AustinEast/524db026a4fea298a0eebf19459131cc
class FlxEcho extends FlxBasic {
	/**
	 * Gets the FlxEcho instance, which contains the current Echo World. May be Null if `FlxEcho.init` has not been called.
	 */
	public static var instance(default, null):FlxEcho;

	/**
	 * Toggles whether the physics simulation updates or not.
	 */
	public static var updates:Bool;

	/**
	 * Set this to `true` to have each physics body's acceleration reset after updating the physics simulation. Useful if you want to treat acceleration as a non-constant force.
	 */
	public static var reset_acceleration:Bool;

	/**
	 * Toggles whether the physics' debug graphics are drawn. Also Togglable through the Flixel Debugger (click the "E" icon). If Flixel isnt ran with Debug mode, this does nothing.
	 */
	public static var draw_debug(default, set):Bool;

	public var world(default, null):World;
	public var groups:Map<FlxGroup, Array<Body>>;
	public var bodies:Map<FlxObject, Body>;

	#if FLX_DEBUG
	public static var debug_drawer:OpenFLDebug;

	static var draw_debug_button:FlxSystemButton;

	static var icon_data = [
		[0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0], [0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0], [0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0], [0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0], [0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0], [0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0], [0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0], [0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]];
	#end

	/**
	 * Init the Echo physics simulation
	 */
	public static function init(options:WorldOptions) {
		if (instance == null) {
			instance = new FlxEcho(options);
			FlxG.plugins.add(instance);
			FlxG.signals.preStateSwitch.add(on_state_switch);
		}

		updates = true;
		reset_acceleration = false;

		#if FLX_DEBUG
		var icon = new BitmapData(11, 11, true, FlxColor.TRANSPARENT);
		for (y in 0...icon_data.length)
			for (x in 0...icon_data[y].length)
				if (icon_data[y][x] > 0)
					icon.setPixel32(x, y, FlxColor.WHITE);
		if (draw_debug_button == null) {
			draw_debug_button = FlxG.debugger.addButton(RIGHT, icon, () -> draw_debug = !draw_debug, true, true);
		}
		draw_debug = draw_debug;
		#end
	}

	/**
	 * add physics body to FlxObject
	 */
	public static function add_body(object:FlxObject, ?options:BodyOptions):Body {
		var old_body = instance.bodies.get(object);
		if (old_body != null) {
			old_body.dispose();
		}

		if (options == null)
			options = {};
		if (options.x == null)
			options.x = object.x;
		if (options.y == null)
			options.y = object.y;
		if (options.shape == null && options.shapes == null && options.shape_instance == null && options.shape_instances == null)
			options.shape = {
				type: RECT,
				width: object.width,
				height: object.height
			}
		var body = new Body(options);
		instance.bodies.set(object, body);
		instance.world.add(body);
		return body;
	}

	/**
	 * Associates a FlxGroup to a physics group
	 */
	public static function add_group_bodies(group:FlxGroup) {
		if (!instance.groups.exists(group))
			instance.groups.set(group, []);
	}

	/**
	 * Adds FlxObject to FlxGroup, and the FlxObject's associated physics body to the FlxGroup's associated physics group
	 */
	public static function add_to_group(object:FlxObject, group:FlxGroup) {
		group.add(object);
		if (!instance.groups.exists(group))
			instance.groups.set(group, []);
		if (instance.bodies.exists(object))
			instance.groups[group].push(instance.bodies[object]);
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
			if (options.separate == null || options.separate)
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
		instance.world.listen(!a.is(FlxObject) ? instance.groups[cast a] : instance.bodies[cast a],
			!b.is(FlxObject) ? instance.groups[cast b] : instance.bodies[cast b], options);
	}

	/**
	 * Get the physics body associated with a FlxObject
	 */
	public static function get_body(object:FlxObject):Body
		return instance.bodies[object];

	public static function set_body(object:FlxObject, body:Body):Body {
		var old_body = instance.bodies.get(object);
		if (old_body != null)
			old_body.dispose();

		instance.bodies.set(object, body);
		instance.world.add(body);
		return body;
	}

	/**
	 * Removes the physics body from the simulation
	 */
	public static function remove_body(body:Body):Bool {
		for (o => b in instance.bodies)
			if (b == body) {
				body.remove();
				instance.bodies.remove(o);
				return true;
			}

		return false;
	}

	/**
	 * Get the FlxObject associated with a physics body
	 */
	public static function get_object(body:Body):FlxObject {
		for (o => b in instance.bodies)
			if (b == body)
				return o;
		return null;
	}

	/**
	 * Removes (and optionally disposes) the physics body associated with the FlxObject
	 */
	public static function remove_object(object:FlxObject, dispose:Bool = true):Bool {
		var body = instance.bodies.get(object);
		if (body == null)
			return false;

		if (dispose)
			body.dispose();

		return instance.bodies.remove(object);
	}

	/**
	 * Gets a FlxGroup's associated physics group
	 */
	public static function get_group_bodies(group:FlxGroup):Null<Array<Body>> {
		return instance.groups.get(group);
	}

	/**
	 * Removes the FlxGroup's associated physics group from the simulation
	 */
	public static function remove_group_bodies(group:FlxGroup) {
		return instance.groups.remove(group);
	}

	/**
	 * Removes the FlxObject from the FlxGroup, and the FlxObject's associated physics body from the FlxGroup's associated physics group
	 */
	public static function remove_from_group(object:FlxObject, group:FlxGroup):Bool {
		group.remove(object);
		if (!instance.groups.exists(group) || !instance.bodies.exists(object))
			return false;
		return instance.groups[group].remove(instance.bodies[object]);
	}

	static function update_body_object(object:FlxObject, body:Body) {
		object.setPosition(body.x, body.y);
		if (object.isOfType(FlxSprite)) {
			var sprite:FlxSprite = cast object;
			sprite.x -= sprite.origin.x;
			sprite.y -= sprite.origin.y;
		}
		object.angle = body.rotation;
		if (reset_acceleration)
			body.acceleration.set(0, 0);
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

	static function on_state_switch() {
		for (body in instance.bodies)
			body.dispose();
		instance.bodies.clear();
		instance.groups.clear();
		instance.world.clear();

		draw_debug = false;

		#if FLX_DEBUG
		if (draw_debug_button != null) {
			FlxG.debugger.removeButton(draw_debug_button);
			draw_debug_button = null;
		}
		#end
	}

	static function set_draw_debug(v:Bool) {
		#if FLX_DEBUG
		if (draw_debug_button != null)
			draw_debug_button.toggled = !v;

		if (v) {
			if (debug_drawer == null) {
				debug_drawer = new OpenFLDebug();
				debug_drawer.camera = AABB.get();
				debug_drawer.draw_quadtree = false;
				debug_drawer.canvas.scrollRect = null;
			}
			FlxG.addChildBelowMouse(debug_drawer.canvas);
		} else if (debug_drawer != null) {
			debug_drawer.clear();
			FlxG.removeChild(debug_drawer.canvas);
		}
		#end

		return draw_debug = v;
	}

	public function new(options:WorldOptions) {
		super();
		groups = [];
		bodies = [];
		world = Echo.start(options);
	}

	override public function update(elapsed:Float) {
		if (updates)
			world.step(elapsed);

		for (object => body in bodies)
			update_body_object(object, body);
	}

	#if FLX_DEBUG
	@:access(flixel.FlxCamera)
	override function draw() {
		super.draw();

		if (!draw_debug || debug_drawer == null || world == null)
			return;

		// TODO - draw with full FlxG.cameras list
		debug_drawer.camera.set_from_min_max(FlxG.camera.scroll.x, FlxG.camera.scroll.y, FlxG.camera.scroll.x + FlxG.camera.width,
			FlxG.camera.scroll.y + FlxG.camera.height);

		debug_drawer.draw(world);

		var s = debug_drawer.canvas;
		s.x = s.y = 0;
		s.scaleX = s.scaleY = 1;
		FlxG.camera.transformObject(s);
	}
	#end

	override function destroy() {
		super.destroy();

		for (body in bodies)
			body.dispose();
		bodies.clear();
		groups.clear();
		world.dispose();

		bodies = null;
		groups = null;
		world = null;
	}
}
