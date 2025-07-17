#@tool
extends Node2D

@onready var rolmaat = get_parent().get_parent().get_parent().get_node("rolmaat")
@onready var player = get_node("map_player")

@export var WALL_THICKNESS = 5
@export var VIEW_SCALE = 50 # pixels per meter
var DOOR_WIDTH = 25

var wall_texture = load("res://assets/map-assets_walls.png")
var door_texture = load("res://assets/map-assets_door.png")
var door_scribble_texture = load("res://assets/map-assets_door-scribble.png")

var mapping_new_room = false

func _ready() -> void:
	for i in range(complex.rooms.size()):
		var room = complex.rooms[i]
		if(!room.mapped): continue
		var room_node = new_room(room.x, room.y, room.w, room.h, i)
		add_child(room_node)
	for i in range(complex.doors.size()):
		var door = complex.doors[i]
		if(door.mapped):
			var door_node = new_door(i, "technical")
			add_child(door_node)
		elif(door.scribbled):
			var door_node = new_door(i, "scribble")
			add_child(door_node)

func _process(delta: float) -> void:
	player.position = complex.player.position * VIEW_SCALE - Vector2(4.5, 14)
	player.rotation = rot_from_ori(complex.player.orientation)
	
	var room_index = complex.player.room
	var room = complex.rooms[complex.player.room]
	if(!room.mapped):
		var room_node = get_node_or_null("room_plan_{index}".format({"index": int(room_index)}))
		if(room_node == null):
			room_node = new_room(room.x, room.y, 0.1, 0.1, room_index)
			room_node.scale = Vector2(0,0)
			add_child(room_node)
		
		if(rolmaat.dragging):
			room_node.scale = Vector2(1,1)
		
		var rolmaat_size = (rolmaat.tapeje.size.x - rolmaat.tapeje_base_width) / (rolmaat.PIXEL_RANGE * rolmaat.goal/rolmaat.MAX_GOAL)
		match rolmaat.progress:
			rolmaat.mapping_progress.init: 
				room_node.size.x = 5 + max(5, rolmaat_size * room.w * VIEW_SCALE)
			rolmaat.mapping_progress.width_done: 
				room_node.size.y = 5 + max(5, rolmaat_size * room.h * VIEW_SCALE)

func new_room(x, y, w, h, room_index) -> NinePatchRect:
	var room = NinePatchRect.new()
	room.name = "room_plan_{index}".format({"index": int(room_index)})
	room.set_texture(wall_texture)
	room.region_rect = Rect2(0, 0, 30, 30)
	room.axis_stretch_horizontal = NinePatchRect.AXIS_STRETCH_MODE_TILE
	room.axis_stretch_vertical = NinePatchRect.AXIS_STRETCH_MODE_TILE
	for i in range(4):
		room.set_patch_margin(i, WALL_THICKNESS)
	room.position = Vector2(x * VIEW_SCALE - WALL_THICKNESS * 0.5, y * VIEW_SCALE - WALL_THICKNESS * 0.5)
	room.size = Vector2(w * VIEW_SCALE + WALL_THICKNESS, h * VIEW_SCALE + WALL_THICKNESS)	
	return room

func new_door(door_index, draw_mode) -> TextureRect:
	var door_object = complex.doors[door_index]
	var x = door_object.x
	var y = door_object.y
	var orientation = door_object.orientation
	var door = TextureRect.new()
	if(draw_mode == "technical"):
		door.set_texture(door_texture)
	if(draw_mode == "scribble"):
		door.set_texture(door_scribble_texture)
	door.name = "door_plan_{index}".format({"index": int(door_index)})
	door.position = Vector2(x * VIEW_SCALE - WALL_THICKNESS * 0.5, 
		y * VIEW_SCALE - WALL_THICKNESS * 0.5
		) + door_offset[orientation]
	door.size = Vector2(30, DOOR_WIDTH)
	door.rotation = rot_from_ori(orientation)
	door.z_index = 1
	return door

func map_scribbled_door(door_index) -> void:
	var door_node = get_node_or_null("door_plan_{index}".format({"index": int(door_index)}))
	door_node.set_texture(door_texture)

func rot_from_ori(orientation) -> float:
	return 0.5 * PI * orientation

var door_offset = [ # ja dit is helaas toch echt nodig
	Vector2(0,0),
	Vector2(DOOR_WIDTH, 0),
	Vector2(WALL_THICKNESS, DOOR_WIDTH),
	Vector2(0, WALL_THICKNESS),
]
