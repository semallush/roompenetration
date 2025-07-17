extends Area3D

signal pressed
signal hover

var door_index = -1
func _on_mouse_entered() -> void:
	emit_signal("hover", door_index)
	highlight(true)

func _on_mouse_exited() -> void:
	highlight(false)

func highlight(on: bool):
	if on:
		var highlight_mat = StandardMaterial3D.new()
		highlight_mat.albedo_color = Color.YELLOW
		$door_mesh.material_override = highlight_mat
	else:
		$door_mesh.material_override = null  # Revert to original


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		emit_signal("pressed", door_index, event.button_index)
