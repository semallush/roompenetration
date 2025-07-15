@tool

class_name Room extends Node3D

const ROOM_SCENE = preload("res://scenes/room/room_view.tscn")
const DOOR_SCENE = preload("res://scenes/door/door.tscn")

const ROOM_HEIGHT: float = 2

var room_doors
var player_door_index
var player_orientation

var room_width
var room_depth

# this is the 2d coordinate of the nw corner in map view 
# here it is used to offset door coords which are given relative to this corner in map view
var room_corner

		
static func new_room(room_size:Vector2, room_doors, player_door_index, player_orientation):
	var new_room = ROOM_SCENE.instantiate()
	
	# room_doors are pairs of positions, orientations and indices
	new_room.room_doors = room_doors
	
	new_room.player_door_index = player_door_index
	new_room.player_orientation = player_orientation
	
	# flip width and depth depending on orientation of player. used for generating the 3d room walls.
	if player_orientation == complex.orient.north || player_orientation == complex.orient.south:
		new_room.room_width = room_size.x
		new_room.room_depth = room_size.y
	else:
		new_room.room_width = room_size.y
		new_room.room_depth = room_size.x
		
	# used to offset door coordinates so the origin is in the centre of the room instead of the NW corner
	new_room.room_corner = Vector2(-room_size.x/2, -room_size.y/2)
   
	new_room.generate_room()
	new_room.generate_doors()
	
	return new_room
	
func _ready() -> void:
	pass

	

func generate_room() -> void:
	
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
	
func generate_doors() -> void:
		
	var orientations = map_orientations(player_orientation)

	for door in room_doors:
		if door.index == player_door_index:
			# this is the door the player is standing in
			continue
			
		# this calcualates the rotation of the door
		var rotation 
		if door.orient == orientations.left:
			rotation = Vector3(-PI/2,PI/2,0)
		elif door.orient == orientations.right:
			rotation = Vector3(-PI/2,-PI/2,0)
		elif door.orient == orientations.back:
			rotation = Vector3(-PI/2,0,0)
		else:
			rotation = Vector3(-PI/2,0,0)
		
		# this adjusts the position of the door so the origin is in the centre (2d coordinate)
		var x =  room_corner.x + door.pos.x 
		var y = room_corner.y + door.pos.y
		
		# this rotates the coordinate based on the direction the player is facing
		var adj_door_pos = Vector2(x,y)
		match player_orientation:
			complex.orient.east:
				adj_door_pos = adj_door_pos.rotated(-PI/2)
			complex.orient.south:
				adj_door_pos = adj_door_pos.rotated(-PI)
			complex.orient.west:
				adj_door_pos = adj_door_pos.rotated(-PI*3/2)
				

		spawn_door(adj_door_pos.x, adj_door_pos.y, rotation, door.index)

		
func update_camera() -> void:
	# maybe this is ugly. idk what the best node hierarchy is
	get_node("camera").position = Vector3(0, ROOM_HEIGHT/2, room_depth/2+1)

func map_orientations(p_orient) -> Dictionary:
	# maps orientations to different positions from camera view
	# this can be done in a smarter way probably
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
	
func spawn_door(x, z, rot, i) -> void:
	var new_door = DOOR_SCENE.instantiate()
	new_door.door_index = i
	new_door.position = Vector3(x, 0, z)
	new_door.rotation = rot
	add_child(new_door)
	new_door.pressed.connect(_on_door_pressed)

func _on_door_pressed(door_index):
	print("entering door with index: ", door_index)
	complex.enter_room(door_index)
