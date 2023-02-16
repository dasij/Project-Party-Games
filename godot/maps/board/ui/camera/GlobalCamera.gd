extends KinematicBody2D

onready var GlobalCamera := $Camera as Camera2D

export var speed := 200
export var zoom_speed := 0.01
export var zoom_min := 0.75
export var zoom_max := 1.15

var velocity := Vector2.ZERO

func activate() -> void:
	self.set_process(true)

func deactivate() -> void:
	self.set_process(false)

func get_camera():
	return GlobalCamera 

func get_input() -> void:
	var viewport_size := get_viewport().size / 2
	
	velocity = Vector2.ZERO
	if Input.is_action_pressed('ui_right'):
		if position.x + viewport_size.x * GlobalCamera.zoom.x < GlobalCamera.limit_right:
			velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		if position.x - viewport_size.x * GlobalCamera.zoom.x > GlobalCamera.limit_left:
			velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		if position.y + viewport_size.y * GlobalCamera.zoom.y < GlobalCamera.limit_bottom:
			velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		if position.y - viewport_size.y * GlobalCamera.zoom.y > GlobalCamera.limit_top:
			velocity.y -= 1
	if Input.is_action_pressed("zoom_in"):
		var zoom := GlobalCamera.zoom.x
		var new_zoom := min(zoom_max, zoom + zoom_speed)
		GlobalCamera.zoom = Vector2(new_zoom, new_zoom)
		position = GlobalCamera.get_camera_screen_center()
	if Input.is_action_pressed("zoom_out"):
		var zoom := GlobalCamera.zoom.x
		var new_zoom := max(zoom_min, zoom - zoom_speed)
		GlobalCamera.zoom = Vector2(new_zoom, new_zoom)
		position = GlobalCamera.get_camera_screen_center()
	velocity = velocity.normalized() * speed
	
func _process(delta):
	get_input()
	velocity = move_and_slide(velocity)

func _ready():
	GlobalCamera.align()
