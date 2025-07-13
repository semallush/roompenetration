@tool

extends Node3D

@export var room_width: float = 1
@export var room_depth: float = 1
@export var room_height: float = 2
@export var show_door_left = false
@export var show_door_right = false
@export var show_door_back = false

@export var reload = false :
	set(new_reload):
		reload = false
		update_room()
		update_doors()
		update_camera()

func _ready() -> void:
	update_room()
	update_doors()
	update_camera()




func update_room() -> void:
	
	$floor.mesh = PlaneMesh.new()
	$floor.mesh.size = Vector2(room_width, room_depth)
	
	$ceiling.mesh = PlaneMesh.new()
	$ceiling.mesh.size = Vector2(room_width, room_depth)
	$ceiling.rotation = Vector3(0,0,PI)
	$ceiling.position = Vector3(0,room_height,0)
	
	$wall_left.mesh = PlaneMesh.new()
	$wall_left.mesh.size = Vector2(room_height, room_depth)
	$wall_left.position = Vector3(-room_width/2, room_height/2, 0)
	$wall_left.rotation = Vector3(0,0, -PI/2)
	
	$wall_right.mesh = PlaneMesh.new()
	$wall_right.mesh.size = Vector2(room_height, room_depth)
	$wall_right.position = Vector3(room_width/2, room_height/2, 0)
	$wall_right.rotation = Vector3(0,0, PI/2)

	$wall_back.mesh = PlaneMesh.new()
	$wall_back.mesh.size = Vector2(room_width, room_height) 
	$wall_back.position = Vector3(0, room_height/2, -room_depth/2)
	$wall_back.rotation = Vector3(PI/2,0,0)
	
	$black_bar_left.mesh = PlaneMesh.new()
	$black_bar_left.mesh.size = Vector2(room_width, room_height) 
	$black_bar_left.position = Vector3(-room_width, room_height/2, room_depth/2)
	$black_bar_left.rotation = Vector3(PI/2,0,0)
	
	$black_bar_right.mesh = PlaneMesh.new()
	$black_bar_right.mesh.size = Vector2(room_width, room_height) 
	$black_bar_right.position = Vector3(room_width, room_height/2, room_depth/2)
	$black_bar_right.rotation = Vector3(PI/2,0,0)
func update_doors() -> void:
	# add size and rotation in here as well so it's all in code
	if show_door_left:
		$door_left.visible = true
		$door_left.position = Vector3(-room_width/2, 0, 0)
	else:
		$door_left.visible = false
		
	if show_door_right:
		$door_right.visible = true
		$door_right.position = Vector3(room_width/2, 0, 0)
	else:
		$door_right.visible = false
	
	if show_door_back:
		$door_back.visible = true
		$door_back.position = Vector3(0, 0, -room_depth/2)
	else:
		$door_back.visible = false
		
func update_camera() -> void:
	# maybe this is ugly. idk what the best node hierarchy is
	get_node("camera").position = Vector3(0, room_height/2, room_depth/2+1)
