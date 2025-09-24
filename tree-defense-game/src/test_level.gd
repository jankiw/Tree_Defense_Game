extends Node

var camera_left = 0;
var camera_right = 0;
var camera_up = 0;
var camera_down = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Spawner.start()
