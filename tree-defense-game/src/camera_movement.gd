extends CharacterBody2D

const MIN_ZOOM: float = 1.0
const MAX_ZOOM: float = 20

var zoom_step: float = 0.1
var zoom_speed: float = 10
var zoom: float = 1.0
var target_zoom: float = 1.0

var left_bounds: int
var right_bounds: int
var up_bounds: int
var down_bounds: int

var move_speed: float = 400

var width: int
var height: int

func set_bounds(left: int, right: int, up: int, down: int) -> void:
	left_bounds = left
	right_bounds = right
	up_bounds = up
	down_bounds = down

#Moving camera with keyboard
func get_input() -> void:
	var direction = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	velocity = direction * move_speed

func _ready() -> void:
	width = get_viewport().get_visible_rect().size.x / 2
	height = get_viewport().get_visible_rect().size.y / 2
	set_bounds(position.x, position.x, position.y, position.y)
	
func _unhandled_input(event: InputEvent) -> void:
	#moving camera with left mouse button
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT || event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			position -= event.relative / $MainCamera.zoom
			_check_bounds()
	#zooming camera in and out
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				_zoom_out()
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				_zoom_in()

#zoom step multiplied by current zoom because otherwise zooming in at zoom 8 would be 
#much slower than at zoom 1, for example.
func _zoom_in() -> void:
	target_zoom = max(target_zoom - zoom_step * zoom, MIN_ZOOM)
	
func _zoom_out() -> void:
	target_zoom = min(target_zoom + zoom_step * zoom, MAX_ZOOM)

func _zoom_camera(delta) -> void:
	if !is_equal_approx(zoom, target_zoom):
		$MainCamera.zoom = lerp(zoom * Vector2.ONE, target_zoom * Vector2.ONE, zoom_speed * delta)
		zoom = $MainCamera.zoom[0]
		
#compares camera position to the level's set bounds. upper bound applies to the lower edge
#of the camera, right bound applies to the left edge, etc. Checked dynamically in case a level
#expands the bounds.
func _check_bounds() -> void:
	var current_width: int = width/zoom
	var current_height: int = height/zoom
	if position.x + current_width < left_bounds:
		position.x = left_bounds - current_width
	if  right_bounds < position.x - current_width:
		position.x = right_bounds + current_width
	if position.y + current_height < up_bounds:
		position.y = up_bounds - current_height
	if  down_bounds < position.y - current_height:
		position.y = down_bounds + current_height
	
func _physics_process(delta) -> void:
	get_input()
	move_and_slide()
	_zoom_camera(delta)
	_check_bounds()
