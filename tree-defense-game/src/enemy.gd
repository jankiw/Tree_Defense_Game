extends Path2D

var speed: float = 1
var hp: int = 10
var grid_size: int
var seed: String
var physics_on: bool = false

func init(grid_size: int, seed: String) -> void:
	self.grid_size = grid_size
	self.seed = seed
	physics_on = true
	

func _physics_process(delta: float) -> void:
	if !physics_on:
		return
	$PathFollow.progress += speed * delta * grid_size
	if $PathFollow.progress_ratio >= 1:
		_arrive()
		
func _arrive() -> void:
	queue_free()
