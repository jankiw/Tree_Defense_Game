extends CharacterBody2D

const MIN_ZOOM = 1.0
const MAX_ZOOM = 20

var zoom_step = 0.1
var zoom_speed = 10
var zoom = 1.0
var target_zoom = 1.0

var move_speed = 400

var width
var height

func _ready():
	width = get_viewport().get_visible_rect().size.x / 2
	height = get_viewport().get_visible_rect().size.y / 2

func get_input():
	var direction = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	velocity = direction * move_speed
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			position -= event.relative / $MainCamera.zoom
			check_bounds()
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_in()
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_out()

#zoom step multiplied by current zoom because otherwise zooming in at zoom 8 would be 
#much slower than at zoom 1, for example.
func zoom_in():
	target_zoom = max(target_zoom - zoom_step * zoom, MIN_ZOOM)
	
func zoom_out():
	target_zoom = min(target_zoom + zoom_step * zoom, MAX_ZOOM)

func zoom_camera(delta):
	if !is_equal_approx(zoom, target_zoom):
		$MainCamera.zoom = lerp(zoom * Vector2.ONE, target_zoom * Vector2.ONE, zoom_speed * delta)
		zoom = $MainCamera.zoom[0]
		
	
func check_bounds():
	var level = get_parent()
	if position.x + width / zoom < level.camera_left:
		position.x = level.camera_left - width / zoom
	if  level.camera_right < position.x - width / zoom:
		position.x = level.camera_right + width / zoom
	if position.y + height / zoom < level.camera_up:
		position.y = level.camera_up - height / zoom
	if  level.camera_down < position.y - height / zoom:
		position.y = level.camera_down + height / zoom
	
	
func _physics_process(delta):
	get_input()
	move_and_slide()
	zoom_camera(delta)
	check_bounds()
