extends Node

@onready var rolmaat = get_tree().root.get_node("world/rolmaat")
@onready var scribble = get_tree().root.get_node("world/scribble")
@onready var tooltip = get_tree().root.get_node("world/tooltip")
@onready var map_view = get_tree().root.get_node("world/map_view/edge/map_view")
@onready var room_parent = get_tree().root.get_node("world/SubViewportContainer/SubViewport")

# draw maps on https://editor.p5js.org/dakerlogend/sketches/vXFGbJ8Df
var rooms_json = "penis.json"

var player
var rooms = []
var doors = []

var scribbling_timestamp = 0
var scribbling_door = -1
var SCRIBBLE_TIME = 19 * (1000/15) # based on the animation rn lol

func door_matches_wall(door, direction, room) -> bool:
	return ((door.room_out == room and door.wall_out == direction) or 
			(door.room_in  == room and door.wall_in == direction))

func _input(event) -> void:
	if(event is InputEventKey and event.pressed):
		var room_index = complex.player.room
		var door
		match event.keycode:
			KEY_W:
				door = complex.doors.find_custom(func (d): return door_matches_wall(d, orient.north, room_index))
			KEY_A:
				door = complex.doors.find_custom(func (d): return door_matches_wall(d, orient.west, room_index))
			KEY_S:
				door = complex.doors.find_custom(func (d): return door_matches_wall(d, orient.south, room_index))
			KEY_D:
				door = complex.doors.find_custom(func (d): return door_matches_wall(d, orient.east, room_index))
			_:
				return
		if(door>-1):
			enter_room(door)

func enter_room(door_index) -> void:
	stop_hovering_on_door()
	var new_door = doors[door_index]
	var in_door = player.room == new_door.room_in
	
	var room_index = new_door.room_out if in_door else new_door.room_in
	
	player.door = door_index
	player.room = room_index
	player.orientation = new_door.wall_in if in_door else new_door.wall_out
	var vertical_offset = -0.2 if [orient.west, orient.south].has(player.orientation) else 0.2
	player.position = Vector2(new_door.x, new_door.y) + Vector2(0.2, vertical_offset).rotated(0.5 * PI * player.orientation)
	
	rolmaat.enter_room()
	
	# laad nieuwe kamer in
	var room_doors = collect_room_doors(room_index)
	var room_size = Vector2(rooms[room_index].w, rooms[room_index].h)
	var new_room = Room.new_room(room_size, room_doors, player.door, player.orientation)
	
	# removes old room (the room in the editor is only there for adjusting the UI, it should get deleted right away)
	for child in room_parent.get_children():
		child.queue_free()
	room_parent.add_child(new_room)

func hovering_on_door(door_index) -> void:
	if(!doors[door_index].scribbled):
		scribbling_door = door_index
		scribbling_timestamp = Time.get_ticks_msec()
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		scribble.set_frame(0)
		scribble.play("scribble")
	elif(!doors[door_index].mapped):
		tooltip.show_tooltip = true

func stop_hovering_on_door() -> void:
	tooltip.show_tooltip = false
	scribbling_door = -1
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	return

func map_door(door_index) -> void:
	var door = doors[door_index]
	if(door.scribbled and !door.mapped):
		door.mapped = true
		map_view.map_scribbled_door(door_index)

func collect_room_doors(room_index) -> Array:
	# collects necessary door information ("room" doors) for generating room view room
	var room_doors = []
	for i in range(doors.size()):
		if doors[i].room_in == room_index || doors[i].room_out == room_index:
			var door_x = doors[i].x-rooms[room_index].x
			var door_y = doors[i].y-rooms[room_index].y
			
			var door = {
				pos = Vector2(door_x,door_y),
				orient = doors[i].orientation,
				index = i
			}
			room_doors.append(door)
	return room_doors

func _ready() -> void:
	var file = FileAccess.open("res://assets/room json/" + rooms_json, FileAccess.READ)
	var json_string = file.get_as_text()
	var json = JSON.new()
	json.parse(json_string)
	
	player = json.data.player
	rooms = json.data.rooms
	doors = json.data.doors
	
	#need to map ints back to ints. this is fucking lame. if the json gets more complicated we should just write a proper mapping function
	player.room = int(player.room)
	player.orientation = int(player.orientation)
	player.position = Vector2(player.position[0], player.position[1])
	for door in doors:
		door.room_in = int(door.room_in)
		door.room_out = int(door.room_out)
		door.wall_in = int(door.wall_in)
		door.wall_out = int(door.wall_out)
		door.orientation = int(door.orientation)
		
	# laad eerste kamer in
	var room_index = player.room
	var room_doors = collect_room_doors(room_index)
	var room_size = Vector2(rooms[room_index].w, rooms[room_index].h)
	var new_room = Room.new_room(room_size, room_doors, player.door, player.orientation)
	
	# removes old room (the room in the editor is only there for adjusting the UI, it should get deleted right away)
	for child in room_parent.get_children():
		child.queue_free()
	room_parent.add_child(new_room)

func _process(delta: float) -> void:
	if(scribbling_door != -1 and Time.get_ticks_msec() - scribbling_timestamp > SCRIBBLE_TIME):
		var door = doors[scribbling_door]
		door.scribbled = true
		var door_node = map_view.new_door(scribbling_door, "scribble")
		map_view.add_child(door_node)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		scribbling_door = -1
		tooltip.show_tooltip = true
		tooltip.play()

enum orient {
	east = 0,
	south = 1,
	west = 2,
	north = 3
}
