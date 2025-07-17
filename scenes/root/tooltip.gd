extends AnimatedSprite2D

var show_tooltip = false

func _process(delta: float) -> void:
	if(show_tooltip):
		position = get_viewport().get_mouse_position() + Vector2(25, 0)
	else:
		position = Vector2(-100,-100)
