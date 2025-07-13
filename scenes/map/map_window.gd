extends Node

@onready var map_view = find_child("map_view")
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
