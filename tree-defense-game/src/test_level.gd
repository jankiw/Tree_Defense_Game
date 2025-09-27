extends Node

var grid_size: int = 32
var seed: String

var wave_delay: float = 5
var waves_finished: int = 0
var spawners: Array

#(0,0) is bottom right, road grid is off center.
var paths: Array = [
	[[-2,-3], [1,-3], [1,1], [0,1], [0,0], [-1,0], [-1,1]],
	[[4,-1], [1,-1], [1,1], [0,1], [0,0], [-1,0], [-1,1]]
]

func init(seed: String) -> void:
	self.seed = seed
	_adjust_bounds()
	_init_spawners()

func _wave_finished() -> void:
	waves_finished += 1
	if waves_finished >= len(spawners):
		waves_finished = 0
		await get_tree().create_timer(wave_delay).timeout
		_spawn_waves()

func _spawn_waves() -> void:
	for spawner in spawners:
			spawner.start_wave(5)

func _init_spawners() -> void:
	spawners = $Spawners.get_children()
	for i in len(spawners):
		spawners[i].initiate(paths[i], grid_size, seed)
		spawners[i].wave_finished.connect(_wave_finished)
	_spawn_waves()
	
func _adjust_bounds() -> void:
	var min_x: int = paths[0][0][0]
	var max_x: int = paths[0][0][0]
	var min_y: int = paths[0][0][1]
	var max_y: int = paths[0][0][1]
	
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
				
	var left: int = (min_x + 1) * grid_size
	var right: int = (max_x) * grid_size
	var up: int = (min_y + 1) * grid_size
	var down: int = (max_y) * grid_size
	$GameCamera.set_bounds(left, right, up, down)
			
