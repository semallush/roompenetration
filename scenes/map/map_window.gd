extends Node

@onready var map_view = find_child("map_view")
@onready var edge = find_child("edge")
var mouse_pos = Vector2(0,0)
var mouse_over = false

func _on_edge_mouse_entered() -> void:
	mouse_over = true

func _on_edge_mouse_exited() -> void:
	mouse_over = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			map_view.scale += Vector2(0.2, 0.2)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			map_view.scale -= Vector2(0.2, 0.2)
		
func _process(delta: float) -> void:
	if(Input.is_action_pressed("lmb") and mouse_over):
		map_view.position += get_viewport().get_mouse_position() - mouse_pos
		
	mouse_pos = get_viewport().get_mouse_position()

func focus_map_on_player() -> void:
	var room = complex.rooms[complex.player.room]
	var room_spos = Vector2(room.x, room.y) * map_view.VIEW_SCALE + map_view.position
	if(room_spos.x < 0): map_view.position.x -= room_spos.x - 15
	if(room_spos.x + room.w * map_view.VIEW_SCALE > edge.size.x): 
		map_view.position.x -= room_spos.x + room.w * map_view.VIEW_SCALE - edge.size.x + 15
	if(room_spos.y < 0): map_view.position.y -= room_spos.y - 15
	if(room_spos.y + room.h * map_view.VIEW_SCALE > edge.size.y): 
		map_view.position.y -= room_spos.y + room.h * map_view.VIEW_SCALE - edge.size.y + 15
