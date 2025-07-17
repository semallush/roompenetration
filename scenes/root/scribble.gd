extends AnimatedSprite2D

func _process(delta: float) -> void:
	if(complex.scribbling_door != -1):
		position = get_viewport().get_mouse_position()
	else:
		position = Vector2(-100,-100)
