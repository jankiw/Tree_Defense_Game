extends Node

var enemy = load("res://scenes/game/test_enemy.tscn")
var instance 

var wave = 0
var last
@export var wave_mobs = [5, 10, 15]
var mobs_left = 0
	
func start():
	last = len(wave_mobs)
	$WaveTimer.start()
	
func _on_wave_timer_timeout():
	mobs_left = wave_mobs[wave]
	$EnemyTimer.start()

func _on_enemy_timer_timeout():
	instance = enemy.instantiate()
	$TestPath.add_child(instance)
	mobs_left -= 1
	if mobs_left <= 0:
		$EnemyTimer.stop()
		wave += 1 
		if wave < last:
			$WaveTimer.start()
