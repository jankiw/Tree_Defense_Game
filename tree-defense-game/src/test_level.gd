extends Node

var grid_size = 32

var camera_left
var camera_right
var camera_up
var camera_down

var spawn_delay = 1.0
var wave_delay = 3.0

var paths = [
	[[-2,-3], [2,-3], [2,2], [1,2], [1,1], [-1,1], [-1,2]],
	[[5,-1], [2,-1], [2,2], [1,2], [1,1], [-1,1], [-1,2]]
]

var wave_mobs = [
	[5, 10, 15],
	[3, 8, 13]
]

func start_spawners():
	var spawners = $Spawners.get_children()
	var delay = spawn_delay / len(spawners)
	for i in len(spawners):
		spawners[i].start(paths[i], wave_mobs[i])
		await get_tree().create_timer(delay).timeout
	
func adjust_bounds():
	var min_x = paths[0][0][0]
	var max_x = paths[0][0][0]
	var min_y = paths[0][0][1]
	var max_y = paths[0][0][1]
	
	for path in paths:
		for point in path:
			if point[0] < min_x:
				min_x = point[0]
			if point[0] > max_x:
				max_x = point[0]
			if point[1] < min_y:
				min_y = point[1]
			if point[1] > max_y:
				max_y = point[1]
				
	camera_left = (min_x + 1) * grid_size
	camera_right = (max_x - 1) * grid_size
	camera_up = (min_y + 1) * grid_size
	camera_down = (max_y - 1) * grid_size
			

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	adjust_bounds()
	start_spawners()
