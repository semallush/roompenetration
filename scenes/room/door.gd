extends Area3D

func _on_mouse_entered() -> void:
	pass # Replace with function body.
	print("mouse in door")
	highlight(true)


func _on_mouse_exited() -> void:
	pass # Replace with function body.
	print("mouse left door")
	highlight(false)

func highlight(on: bool):
	if on:
		var highlight_mat = StandardMaterial3D.new()
		highlight_mat.albedo_color = Color.YELLOW
		$door_mesh.material_override = highlight_mat
	else:
		$door_mesh.material_override = null  # Revert to original
