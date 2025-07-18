extends AnimatedSprite2D

@onready var tapeje = get_node("rolmaat_tapeje")
@onready var muurtje = get_node("rolmaat_muurtje")

var MAX_GOAL = 6
var PIXEL_RANGE = 394
var goal = 0

var muurtje_base_pos
var tapeje_base_pos
var tapeje_base_width
var dragging = false
var mouse_over = false
var mouse_base_x = 0
var speed = 0
var progress = mapping_progress.init
var stop_animation = false

func _ready() -> void:
	muurtje_base_pos = muurtje.position
	tapeje_base_pos = tapeje.position
	tapeje_base_width = tapeje.size.x
	enter_room()

func enter_room() -> void:
	progress = mapping_progress.done if complex.rooms[complex.player.room].mapped else mapping_progress.init
	set_muurtje()
	

func set_muurtje() -> void:
	match progress:
		mapping_progress.init: goal = complex.rooms[complex.player.room].w
		mapping_progress.width_done: goal = complex.rooms[complex.player.room].h
		mapping_progress.done: 
			goal = -100
			complex.rooms[complex.player.room].mapped = true
	muurtje.position = muurtje_base_pos + Vector2(PIXEL_RANGE * goal/MAX_GOAL, 0)
	
func _input(event) -> void:
	if(event is InputEventMouseButton):
		if(event.pressed and mouse_over and !complex.rooms[complex.player.room].mapped):
			dragging = true
			mouse_base_x = get_viewport().get_mouse_position().x
		if(!event.pressed and dragging):
			dragging = false
			
			var dist_to_muurtje = tapeje.size.x - tapeje_base_width - PIXEL_RANGE * goal/MAX_GOAL
			if(abs(dist_to_muurtje) < 10):
				speed = 1
				progress += 1
				set_muurtje()
			else:
				speed = 1
			

func _process(delta: float) -> void:
	if(dragging):
		tapeje.size.x = tapeje_base_width + min(max(0, get_viewport().get_mouse_position().x - mouse_base_x), PIXEL_RANGE * goal/MAX_GOAL)
	if(speed > 0):
		speed += 5
		tapeje.size.x -= speed
		if(tapeje.size.x <= tapeje_base_width):
			tapeje.size.x = tapeje_base_width 
			speed = 0
			play("jiggle")
			tapeje.visible = false
	if(stop_animation):
		play("rest")
		stop()
		tapeje.visible = true
		stop_animation = false
	if(frame == 6):
		stop_animation = true

func _on_tapeje_mouse_entered() -> void:
	mouse_over = true

func _on_tapeje_mouse_exited() -> void:
	mouse_over = false

enum mapping_progress {
	init = 0,
	width_done = 1,
	done = 2
}
