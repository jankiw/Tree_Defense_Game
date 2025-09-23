extends CharacterBody2D

const MIN_ZOOM = 1.0
const MAX_ZOOM = 10

var zoom_step = 0.2
var zoom_speed = 10
var zoom = 1.0
var target_zoom = 1.0

var move_speed = 400

func get_input():
	var direction = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	velocity = direction * move_speed
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			position -= event.relative / $MainCamera.zoom
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_in()
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_out()

func zoom_in():
	target_zoom = max(target_zoom - zoom_step, MIN_ZOOM)
	set_physics_process(true)
	
func zoom_out():
	target_zoom = min(target_zoom + zoom_step, MAX_ZOOM)
	set_physics_process(true)
	

func _physics_process(delta):
	get_input()
	move_and_slide()
	zoom = lerp(zoom * Vector2.ONE, target_zoom * Vector2.ONE, zoom_speed * delta)
	$MainCamera.zoom = zoom
