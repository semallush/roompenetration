#@tool
extends Node2D

@onready var complex = get_parent().get_parent().get_parent().get_node("complex")
@onready var rolmaat = get_parent().get_parent().get_parent().get_node("rolmaat")
@onready var player = get_node("map_player")

@export var WALL_THICKNESS = 5
@export var VIEW_SCALE = 50 # pixels per meter
var DOOR_WIDTH = 25

var wall_texture = load("res://assets/map-assets_walls.png")
var door_texture = load("res://assets/map-assets_door.png")

var mapping_new_room = false

func _ready() -> void:
	for i in range(complex.rooms.size()):
		var room = complex.rooms[i]
		if(!room.mapped): continue
		var room_node = new_room(room.x, room.y, room.w, room.h, i)
		add_child(room_node)
	for door in complex.doors:
		var room = complex.rooms[door.room_in]
		if(door.mapped):
			var door_node = new_door(door.x, door.y, door.orientation)
			add_child(door_node)
		elif(door.scribbled):
			assert( 0, "SCRIBBLED DOORS NOT YET IMPLEMENTED")

func _process(delta: float) -> void:
	player.position = complex.player.position * VIEW_SCALE - Vector2(4.5, 14)
	player.rotation = rot_from_ori(complex.player.orientation)
	
	var room_index = complex.player.room
	var room = complex.rooms[complex.player.room]
	if(!room.mapped):
		var room_node = get_node("room_plan_{index}".format({"index": room_index}))
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
	
	
	
	#var i = 0
	#for room in complex.rooms:
		#if(!room.mapped): continue
		#var mapped_room = get_node("room_plan_{index}".format({"index": i}))
		#i += 1

func new_room(x, y, w, h, room_index) -> NinePatchRect:
	var room = NinePatchRect.new()
	room.name = "room_plan_{index}".format({"index": room_index})
	room.set_texture(wall_texture)
	room.region_rect = Rect2(0, 0, 30, 30)
	room.axis_stretch_horizontal = NinePatchRect.AXIS_STRETCH_MODE_TILE
	room.axis_stretch_vertical = NinePatchRect.AXIS_STRETCH_MODE_TILE
	for i in range(4):
		room.set_patch_margin(i, WALL_THICKNESS)
	room.position = Vector2(x * VIEW_SCALE - WALL_THICKNESS * 0.5, y * VIEW_SCALE - WALL_THICKNESS * 0.5)
	room.size = Vector2(w * VIEW_SCALE + WALL_THICKNESS, h * VIEW_SCALE + WALL_THICKNESS)	
	return room

func new_door(x, y, orientation) -> TextureRect:
	var door = TextureRect.new()
	door.set_texture(door_texture)
	door.position = Vector2(x * VIEW_SCALE - WALL_THICKNESS * 0.5, 
		y * VIEW_SCALE - WALL_THICKNESS * 0.5
		) + door_offset[orientation]
	door.size = Vector2(30, DOOR_WIDTH)
	door.rotation = rot_from_ori(orientation)
	door.z_index = 1
	return door

func rot_from_ori(orientation) -> float:
	return 0.5 * PI * orientation

var door_offset = [ # ja dit is helaas toch echt nodig
	Vector2(0,0),
	Vector2(DOOR_WIDTH, 0),
	Vector2(WALL_THICKNESS, DOOR_WIDTH),
	Vector2(0, WALL_THICKNESS),
]
