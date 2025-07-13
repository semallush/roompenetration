extends Node2D

const WALL_THICKNESS = 5

var room_texture = load("res://assets/walls_9patch.png")

func _ready() -> void:
	for room in sample_rooms:
		var room_node = new_room(room.x, room.y, room.w, room.h)
		add_child(room_node)

func new_room(x, y, w, h) -> NinePatchRect:
	var room = NinePatchRect.new()
	room.set_texture(room_texture)
	room.region_rect = Rect2(0, 0, 30, 30)
	room.axis_stretch_horizontal = NinePatchRect.AXIS_STRETCH_MODE_TILE
	room.axis_stretch_vertical = NinePatchRect.AXIS_STRETCH_MODE_TILE
	for i in range(4):
		room.set_patch_margin(i, WALL_THICKNESS)
	room.position = Vector2(x - WALL_THICKNESS/2, y - WALL_THICKNESS/2)
	room.size = Vector2(w + WALL_THICKNESS, h + WALL_THICKNESS)	
	return room

const sample_rooms = [
	{
		x = 20,
		y = 20,
		w = 200,
		h = 150
	},
	{
		x = 220,
		y = 80,
		w = 170,
		h = 240
	},
	{
		x = 60,
		y = 170,
		w = 160,
		h = 220
	},
]
