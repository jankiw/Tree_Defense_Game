extends Node

var level = load("res://scenes/game/levels/test_level.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var current_level = level.instantiate()
	add_child(current_level)
