extends Node

const LEVEL = preload("res://scenes/game/levels/test_level.tscn")
var seed: String = "seed"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level = LEVEL.instantiate()
	add_child(level)
	level.init(seed)
