extends Node

var level = load("res://scenes/game/levels/test_level.tscn")
var seed: String = "seed"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level = TestLevel.test_level(seed)
	add_child(level)
	set_physics_process(false)
