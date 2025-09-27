class_name Enemy
extends Path2D

const OWN_PATH: String = "res://scenes/game/test_enemy.tscn"
var is_constructed: bool = false

var speed: float = 1
var hp: int = 10
var grid_size: int
var seed: String
var path: Array

static func enemy(grid_size: int, seed: String, path: Array) -> Enemy:
	var scene = load(OWN_PATH)
	var enemy: Enemy = scene.instantiate()
	enemy.grid_size = grid_size
	enemy.path = path
	enemy.seed = seed
	enemy.is_constructed = true
	return enemy
	
func _ready() -> void:
	while !is_constructed:
		pass
	_add_path()
	
func _add_path() -> void:
	for point in path:
		var x = _convert_distance(point[0])
		var y = _convert_distance(point[1])
		curve.add_point(Vector2(x,y))
		
func _convert_distance(pos: int) -> int:
	pos *= grid_size
	pos += grid_size/2
	return pos

func _physics_process(delta: float) -> void:
	$PathFollow.progress += speed * delta * grid_size
	if $PathFollow.progress_ratio >= 1:
		_arrive()
		
func _arrive() -> void:
	queue_free()
