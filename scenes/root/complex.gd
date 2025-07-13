extends Node

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
]

var doors = [
	{
		scribbled = true,
		mapped = true,
		room_in = 0,
		room_out = 1, # doors open towards room_out
		orientation = orient.east,
		x = rooms[0].x + rooms[0].w, 
		y = rooms[0].y + 1.6
	},
	{
		scribbled = true,
		mapped = true,
		room_in = 0,
		room_out = 2, # doors open towards room_out
		orientation = orient.south,
		x = rooms[0].x + 1.2,
		y = rooms[0].y + rooms[0].h
	},
	{
		scribbled = false,
		mapped = false,
		room_in = 1,
		room_out = 2, # doors open towards room_out
		orientation = orient.west,
		x = rooms[1].x + 0, 
		y = rooms[1].y + 2.4
	},
]

enum orient {
	east = 0,
	south = 1,
	west = 2,
	north = 3
}
