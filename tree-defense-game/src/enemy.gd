extends Path2D

@export var speed = 1
@export var hp = 10
var grid_size
var seed

func _ready():
	grid_size = $"..".grid_size
	seed = $"..".seed

func _physics_process(delta: float) -> void:
	
	$PathFollow.progress += speed * delta * grid_size
	
	if $PathFollow.progress_ratio >= 1:
		arrive()
		
func arrive():
	queue_free()
