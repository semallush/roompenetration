extends Node

var rooms = [
	{
		mapped = false,
		x = 20.0,
		y = 20.0,
		w = 200.0,
		h = 150.0
	},
	{
		x = 220.0,
		y = 80.0,
		w = 170.0,
		h = 240.0
	},
	{
		x = 60.0,
		y = 170.0,
		w = 160.0,
		h = 220.0
	},
]

var doors = [
	{
		scribbled = false,
		mapped = false,
		room_in = 0,
		room_out = 1, # doors open towards room_out
		orientation = orient.right,
		x = rooms[0].w, 
		y = 80
	},
	{
		room_in = 0,
		room_out = 2, # doors open towards room_out
		orientation = orient.down,
		x = 60,
		y = rooms[0].h
	},
	{
		room_in = 1,
		room_out = 2, # doors open towards room_out
		orientation = orient.left,
		x = 0, 
		y = 120
	},
]

enum orient {
	right = 0,
	down = 1,
	left = 2,
	up = 3
}
