@tool

class_name Room extends Node3D

const ROOM_SCENE = preload("res://scenes/room/room_view.tscn")
const DOOR_SCENE = preload("res://scenes/door/door.tscn")

const ROOM_HEIGHT: float = 2

@onready var complex = get_parent().get_parent().get_parent().get_node("complex")

var room_size = Vector2(1,1)
var room_doors
var player_door_index
var player_orientation

var room_width
var room_depth




		
static func new_room(room_size:Vector2, room_doors, player_door_index, player_orientation):
	var new_room = ROOM_SCENE.instantiate()
	new_room.room_size = room_size
	
	# room_doors are pairs of positions, orientations and indices
	new_room.room_doors = room_doors
	
	new_room.player_door_index = player_door_index
	new_room.player_orientation = player_orientation
	
	return new_room
	
func _ready() -> void:
	update_room()
	#update_doors()
	update_camera()
	

func update_room() -> void:
	
	# flip width and depth depending on orientation of player
	if player_orientation == complex.orient.north || player_orientation == complex.orient.south:
		room_width = room_size.x
		room_depth = room_size.y
	else:
		room_width = room_size.y
		room_depth = room_size.x
	
	
	$floor.mesh = PlaneMesh.new()
	$floor.mesh.size = Vector2(room_width, room_depth)
	
	$ceiling.mesh = PlaneMesh.new()
	$ceiling.mesh.size = Vector2(room_width, room_depth)
	$ceiling.rotation = Vector3(0,0,PI)
	$ceiling.position = Vector3(0,ROOM_HEIGHT,0)
	
	$wall_left.mesh = PlaneMesh.new()
	$wall_left.mesh.size = Vector2(ROOM_HEIGHT, room_depth)
	$wall_left.position = Vector3(-room_width/2, ROOM_HEIGHT/2, 0)
	$wall_left.rotation = Vector3(0,0, -PI/2)
	
	$wall_right.mesh = PlaneMesh.new()
	$wall_right.mesh.size = Vector2(ROOM_HEIGHT, room_depth)
	$wall_right.position = Vector3(room_width/2, ROOM_HEIGHT/2, 0)
	$wall_right.rotation = Vector3(0,0, PI/2)

	$wall_back.mesh = PlaneMesh.new()
	$wall_back.mesh.size = Vector2(room_width, ROOM_HEIGHT) 
	$wall_back.position = Vector3(0, ROOM_HEIGHT/2, -room_depth/2)
	$wall_back.rotation = Vector3(PI/2,0,0)
	
	$black_bar_left.mesh = PlaneMesh.new()
	$black_bar_left.mesh.size = Vector2(room_width, ROOM_HEIGHT) 
	$black_bar_left.position = Vector3(-room_width, ROOM_HEIGHT/2, room_depth/2)
	$black_bar_left.rotation = Vector3(PI/2,0,0)
	
	$black_bar_right.mesh = PlaneMesh.new()
	$black_bar_right.mesh.size = Vector2(room_width, ROOM_HEIGHT) 
	$black_bar_right.position = Vector3(room_width, ROOM_HEIGHT/2, room_depth/2)
	$black_bar_right.rotation = Vector3(PI/2,0,0)
	
func update_doors() -> void:
	# flip door coordinates depending on player orientation (this is ugly)
	var door_flipped = true
	if player_orientation == complex.orient.north || player_orientation == complex.orient.south:
		door_flipped = false
		
	var orientations = map_orientations(player_orientation)
	print(orientations)
	for door in room_doors:
		var rotation 
		if door.orient == orientations.left:
			rotation = Vector3(-PI/2,PI/2,0)
		elif door.orient == orientations.right:
			rotation = Vector3(-PI/2,-PI/2,0)
		elif door.orient == orientations.back:
			rotation = Vector3(-PI/2,0,0)
		else:
			continue
			
		var x = door.pos.x
		var z = door.pos.y
		if door_flipped:
				x = door.pos.y
				z = door.pos.x	
			
		spawn_door(x, z, rotation)

		
func update_camera() -> void:
	# maybe this is ugly. idk what the best node hierarchy is
	get_node("camera").position = Vector3(0, ROOM_HEIGHT/2, room_depth/2+1)

func map_orientations(p_orient) -> Dictionary:
	# maps orientations to different positions from camera view
	var l
	var r
	var b
	
	match p_orient:
		complex.orient.east:
			l = complex.orient.south
			r = complex.orient.north
			b = complex.orient.west
		complex.orient.south:
			l = complex.orient.west
			r = complex.orient.east
			b = complex.orient.north
		complex.orient.west:
			l = complex.orient.north
			r = complex.orient.south
			b = complex.orient.east
		complex.orient.north:
			l = complex.orient.east
			r = complex.orient.west
			b = complex.orient.south
	
	var orientations = {
		left = l,
		right = r,
		back = b
	}
	return orientations
	
func spawn_door(x, z, rot) -> void:
	var new_door = DOOR_SCENE.instantiate()
	new_door.position = Vector3(x, z, 0)
	new_door.rotation = rot
	add_child(new_door)
	
