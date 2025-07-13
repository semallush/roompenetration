@tool

class_name Room extends Node3D

const ROOM_SCENE = preload("res://scenes/room/room_view.tscn")
const DOOR_SCENE = preload("res://scenes/door/door.tscn")

const ROOM_HEIGHT: float = 2


var room_size = Vector2(1,1)




@export var reload = false :
	set(new_reload):
		reload = false
		#update_room()
		update_doors()
		update_camera()
		
static func new_room(room_size:Vector2):
	var new_room = ROOM_SCENE.instantiate()
	new_room.room_size = room_size
	
func _ready() -> void:
	#update_room()
	update_doors()
	update_camera()
	spawn_door()

#func update_room() -> void:
	#
	#$floor.mesh = PlaneMesh.new()
	#$floor.mesh.size = Vector2(room_width, room_depth)
	#
	#$ceiling.mesh = PlaneMesh.new()
	#$ceiling.mesh.size = Vector2(room_width, room_depth)
	#$ceiling.rotation = Vector3(0,0,PI)
	#$ceiling.position = Vector3(0,room_height,0)
	#
	#$wall_left.mesh = PlaneMesh.new()
	#$wall_left.mesh.size = Vector2(room_height, room_depth)
	#$wall_left.position = Vector3(-room_width/2, room_height/2, 0)
	#$wall_left.rotation = Vector3(0,0, -PI/2)
	#
	#$wall_right.mesh = PlaneMesh.new()
	#$wall_right.mesh.size = Vector2(room_height, room_depth)
	#$wall_right.position = Vector3(room_width/2, room_height/2, 0)
	#$wall_right.rotation = Vector3(0,0, PI/2)
#
	#$wall_back.mesh = PlaneMesh.new()
	#$wall_back.mesh.size = Vector2(room_width, room_height) 
	#$wall_back.position = Vector3(0, room_height/2, -room_depth/2)
	#$wall_back.rotation = Vector3(PI/2,0,0)
	#
	#$black_bar_left.mesh = PlaneMesh.new()
	#$black_bar_left.mesh.size = Vector2(room_width, room_height) 
	#$black_bar_left.position = Vector3(-room_width, room_height/2, room_depth/2)
	#$black_bar_left.rotation = Vector3(PI/2,0,0)
	#
	#$black_bar_right.mesh = PlaneMesh.new()
	#$black_bar_right.mesh.size = Vector2(room_width, room_height) 
	#$black_bar_right.position = Vector3(room_width, room_height/2, room_depth/2)
	#$black_bar_right.rotation = Vector3(PI/2,0,0)
func update_doors() -> void:
	# add size and rotation in here as well so it's all in code
	pass
	#	$door_left.position = Vector3(-room_width/2, 0, 0)

		

	#	$door_right.position = Vector3(room_width/2, 0, 0)

	#	$door_back.position = Vector3(0, 0, -room_depth/2)

		
func update_camera() -> void:
	pass
	# maybe this is ugly. idk what the best node hierarchy is
	#get_node("camera").position = Vector3(0, room_height/2, room_size.y/2+1)

func spawn_door() -> void:
	var new_door = DOOR_SCENE.instantiate()
	add_child(new_door)
	
