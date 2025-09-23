extends PathFollow2D

@export var speed = 50
@export var hp = 5

func _physics_process(delta: float) -> void:
	
	set_progress(get_progress() + speed * delta)
	
	if get_progress_ratio() >= 1:
		arrive()
		
func arrive():
	queue_free()
