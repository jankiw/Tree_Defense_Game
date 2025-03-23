extends Node

const TEST_PATH = preload("res://scenes/_debug/test_path.tscn")

func _on_spawn_timer_timeout() -> void:
	var temp_path = TEST_PATH.instantiate()
	add_child(temp_path)
