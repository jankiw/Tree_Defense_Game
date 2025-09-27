class_name Spawner
extends Node

const WAVE_END_SIGNAL = "wave_finished"
const OWN_PATH = "res://scenes/game/spawner.tscn"
var is_constructed: bool = false
var random: RandomNumberGenerator

var mobs_left: int = 0
var path: Array
var grid_size: int
var resource
var seed: String
var path_width: float = 0.3
var spawn_delay: float = 1.0
signal wave_finished


static func spawner(path: Array, grid_size: int , seed: String) -> Spawner:
	var scene = load(OWN_PATH)
	var spawner: Spawner = scene.instantiate()
	spawner.path = path
	spawner.grid_size = grid_size
	spawner.seed = seed
	spawner.random = RandomNumberGenerator.new()
	spawner.random.seed = seed.hash()
	spawner.is_constructed = true
	return spawner
	
func start_wave(resources: int) -> void:
	mobs_left = resources
	$EnemyTimer.start()
	
	
func _ready() -> void:
	while !is_constructed:
		pass
	$EnemyTimer.wait_time = spawn_delay
	set_physics_process(false)


func _finish_wave() -> void:
	$EnemyTimer.stop()
	emit_signal(WAVE_END_SIGNAL)
	
func _on_enemy_timer_timeout() -> void:
	_create_enemy()
	mobs_left -= 1
	if mobs_left <= 0:
		_finish_wave()
	
func _create_enemy() -> void:
	var enemy: Enemy = Enemy.enemy(grid_size, seed, path)
	var offset: Vector2 = _get_spawn_offset()
	enemy.position += offset
	add_child(enemy)

func _get_spawn_offset() -> Vector2:
	var actual_width: int = int(grid_size * path_width)
	var x: int = random.randi() % actual_width - actual_width / 2
	var y: int = random.randi() % actual_width - actual_width / 2
	return Vector2(x,y)
