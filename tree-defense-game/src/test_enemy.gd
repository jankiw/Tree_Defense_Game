extends PathFollow2D

var speed = 1
var hp = 10

func _physics_process(delta: float) -> void:
	
	#enemy is child of path that is child of spawner
	set_progress(get_progress() + speed * delta * $"../..".grid_size)
	
	if get_progress_ratio() >= 1:
		arrive()
		
func arrive():
	queue_free()
