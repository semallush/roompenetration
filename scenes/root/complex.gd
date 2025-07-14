extends Node

@onready var rolmaat = get_tree().root.get_node("world/rolmaat")
@onready var room_parent = get_tree().root.get_node("world/SubViewportContainer/SubViewport")

var rooms_json = "test1.json"

var player
var rooms = []
var doors = []

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

enum orient {
	east = 0,
	south = 1,
	west = 2,
	north = 3
}
