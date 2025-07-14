extends Node

@onready var rolmaat = get_parent().get_node("rolmaat")
@onready var room_parent = get_node("../SubViewportContainer/SubViewport")

func _input(event) -> void:
	if(event is InputEventKey and event.pressed):
		match event.keycode:
			KEY_0:
				enter_room(0)
			KEY_1:
				enter_room(1)
			KEY_2:
				enter_room(2)
			KEY_3:
				enter_room(3)
			_:
				return

func enter_room(door_index) -> void:
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
	
	new_room.update_doors()
	new_room.update_room()
	
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
	


var player = {
	room = 0,
	door = 0,
	orientation = orient.east,
	position = Vector2(0.8, 1.9)
}

var rooms = [
	{
		mapped = true,
		x = 0.4,
		y = 0.4,
		w = 4.0,
		h = 3.0
	},
	{
		mapped = false,
		x = 4.4,
		y = 1.6,
		w = 3.4,
		h = 4.8
	},
	{
		mapped = false,
		x = 1.2,
		y = 3.4,
		w = 3.2,
		h = 4.4
	},
	{
		mapped = false,
		x = 4.4,
		y = 6.4,
		w = 2.6,
		h = 3.0
	},
]

var doors = [
	{
		scribbled = true,
		mapped = true,
		room_in = 0,
		room_out = 1, 
		wall_in = orient.east,
		wall_out = orient.west,
		orientation = orient.east,
		x = rooms[0].x + rooms[0].w, 
		y = rooms[0].y + 1.6
	},
	{
		scribbled = true,
		mapped = true,
		room_in = 0,
		room_out = 2, 
		wall_in = orient.south,
		wall_out = orient.north,
		orientation = orient.south,
		x = rooms[0].x + 1.2,
		y = rooms[0].y + rooms[0].h
	},
	{
		scribbled = false,
		mapped = false,
		room_in = 1,
		room_out = 3, 
		wall_in = orient.south,
		wall_out = orient.north,
		orientation = orient.south,
		x = rooms[1].x + 0.8, 
		y = rooms[1].y + rooms[1].h
	},
	{
		scribbled = false,
		mapped = false,
		room_in = 3,
		room_out = 2, 
		wall_in = orient.west,
		wall_out = orient.east,
		orientation = orient.west,
		x = rooms[3].x, 
		y = rooms[3].y + 0.4
	},
]

enum orient {
	east = 0,
	south = 1,
	west = 2,
	north = 3
}
