@tool
extends Node2D

@export var WALL_THICKNESS = 5
var DOOR_WIDTH = 25

var wall_texture = load("res://assets/map-assets_walls.png")
var door_texture = load("res://assets/map-assets_door.png")

func _ready() -> void:
	for room in rooms:
		var room_node = new_room(room.x, room.y, room.w, room.h)
		add_child(room_node)
	for door in doors:
		var room = rooms[door.room_in]
		var door_node = new_door(room.x + door.x, room.y + door.y, door.orientation)
		add_child(door_node)

func new_room(x, y, w, h) -> NinePatchRect:
	var room = NinePatchRect.new()
	room.set_texture(wall_texture)
	room.region_rect = Rect2(0, 0, 30, 30)
	room.axis_stretch_horizontal = NinePatchRect.AXIS_STRETCH_MODE_TILE
	room.axis_stretch_vertical = NinePatchRect.AXIS_STRETCH_MODE_TILE
	for i in range(4):
		room.set_patch_margin(i, WALL_THICKNESS)
	room.position = Vector2(x - WALL_THICKNESS/2, y - WALL_THICKNESS/2)
	room.size = Vector2(w + WALL_THICKNESS, h + WALL_THICKNESS)	
	return room
	
func new_door(x, y, orientation) -> TextureRect:
	var door = TextureRect.new()
	door.set_texture(door_texture)
	door.position = Vector2(x - WALL_THICKNESS / 2, y - WALL_THICKNESS / 2) + door_offset[orientation]
	door.size = Vector2(30, DOOR_WIDTH)
	door.rotation = 0.5 * PI * orientation
	return door

var rooms = [
	{
		x = 20.0,
		y = 20.0,
		w = 200.0,
		h = 150.0
	},
	{
		x = 220.0,
		y = 80.0,
		w = 170.0,
		h = 240.0
	},
	{
		x = 60.0,
		y = 170.0,
		w = 160.0,
		h = 220.0
	},
]

var doors = [
	{
		room_in = 0,
		room_out = 1, # doors open towards room_out
		orientation = orient.right,
		x = rooms[0].w, 
		y = 80
	},
	{
		room_in = 0,
		room_out = 2, # doors open towards room_out
		orientation = orient.down,
		x = 60,
		y = rooms[0].h
	},
	{
		room_in = 1,
		room_out = 2, # doors open towards room_out
		orientation = orient.left,
		x = 0, 
		y = 120
	},
]

var door_offset = [ # ja dit is helaas toch echt nodig
	Vector2(0,0),
	Vector2(DOOR_WIDTH, 0),
	Vector2(WALL_THICKNESS, DOOR_WIDTH),
	Vector2(0, WALL_THICKNESS),
]

enum orient {
	right = 0,
	down = 1,
	left = 2,
	up = 3
}
