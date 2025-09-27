extends Node

const WAVE_END_SIGNAL = "wave_finished"
const ENEMY = preload("res://scenes/game/test_enemy.tscn")

var mobs_left: int = 0
var path: Array
var grid_size: int
var resource
var seed: String
var path_width: float = 0.3
var spawn_delay: float = 1.0
signal wave_finished


func initiate(path: Array, grid_size: int , seed: String) -> void:
	self.path = path
	self.grid_size = grid_size
	self.seed = seed
	seed(seed.hash())
	$EnemyTimer.wait_time = spawn_delay
	
func start_wave(resources: int) -> void:
	mobs_left = resources
	$EnemyTimer.start()
	
	
	
func _finish_wave() -> void:
	$EnemyTimer.stop()
	emit_signal(WAVE_END_SIGNAL)
	
func _on_enemy_timer_timeout() -> void:
	_create_enemy()
	mobs_left -= 1
	if mobs_left <= 0:
		_finish_wave()
	
func _add_path(instance: Path2D) -> void:
	for point in path:
		var x = _convert_distance(point[0])
		var y = _convert_distance(point[1])
		instance.curve.add_point(Vector2(x,y))
		
func _convert_distance(pos: int) -> int:
	pos *= grid_size
	pos += grid_size/2
	return pos
	
func _create_enemy() -> void:
	var instance: Path2D = ENEMY.instantiate()
	_add_path(instance)
	var offset: Vector2 = _get_spawn_offset()
	instance.position += offset
	instance.init(grid_size, seed)
	add_child(instance)

func _get_spawn_offset() -> Vector2:
	var actual_width: int = int(grid_size * path_width)
	var x: int = randi() % actual_width - actual_width / 2
	var y: int = randi() % actual_width - actual_width / 2
	return Vector2(x,y)
