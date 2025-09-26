extends Node

var enemy = load("res://scenes/game/test_enemy.tscn")

var mobs_left = 0
var path
var grid_size
var resource
var seed
var level_handler
var path_width = 0.3

func initiate(parent_path):
	level_handler = get_parent().get_parent()
	path = parent_path
	#spawner is child of spawners which is a child of the level
	grid_size = level_handler.grid_size
	seed = level_handler.seed
	seed(seed.hash())
	$EnemyTimer.wait_time = level_handler.spawn_delay
	
func add_path(instance):
	for point in path:
		var x = convert_distance(point[0])
		var y = convert_distance(point[1])
		instance.curve.add_point(Vector2(x,y))
		
func convert_distance(pos):
	pos *= grid_size
	if pos > 0:
		pos -= grid_size/2
	else:
		pos += grid_size/2
	return pos
	
func start_wave(resources):
	mobs_left = resources
	$EnemyTimer.start()
	
func get_offset():
	var x = ( randi() % int(grid_size * path_width) ) - grid_size * path_width / 2
	var y = ( randi() % int(grid_size * path_width) ) - grid_size * path_width / 2
	return Vector2(x,y)

func _on_enemy_timer_timeout():
	var instance = enemy.instantiate()
	add_path(instance)
	var offset = get_offset()
	instance.position += offset
	add_child(instance)
	mobs_left -= 1
	if mobs_left <= 0:
		$EnemyTimer.stop()
		level_handler.wave_finished()
