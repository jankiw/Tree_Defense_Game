extends Node

var enemy = load("res://scenes/game/test_enemy.tscn")
var instance 

var wave = 0
var last_wave
var wave_mobs
var mobs_left = 0
var path
var grid_size = 0
	
func start(parent_path, parent_wave_mobs):
	path = parent_path
	wave_mobs = parent_wave_mobs
	last_wave = len(wave_mobs)
	#spawner is child of spawners which is a child of the level
	grid_size = $"../..".grid_size
	draw_path()
	$EnemyTimer.wait_time = $"../..".spawn_delay
	$WaveTimer.wait_time = $"../..".wave_delay
	$WaveTimer.start()
	
func draw_path():
	for point in path:
		var x = convert_distance(point[0])
		var y = convert_distance(point[1])
		$Path2D.curve.add_point(Vector2(x,y))
		
func convert_distance(pos):
	pos *= grid_size
	if pos > 0:
		pos -= grid_size/2
	else:
		pos += grid_size/2
	return pos
	
func _on_wave_timer_timeout():
	mobs_left = wave_mobs[wave]
	$EnemyTimer.start()

func _on_enemy_timer_timeout():
	instance = enemy.instantiate()
	$Path2D.add_child(instance)
	mobs_left -= 1
	if mobs_left <= 0:
		$EnemyTimer.stop()
		wave += 1 
		if wave < last_wave:
			$WaveTimer.start()
