extends CharacterBody2D

@onready var _camera := $Camera as Camera2D
@onready var _zoom := $ZoomController as ZoomController
@onready var _movement := $Movement as TopDownMovement

func activate() -> void:
	_movement.activate()
	_zoom.activate()


func deactivate() -> void:
	_movement.deactivate()
	_zoom.deactivate()


func get_camera():
	return _camera


func get_input() -> void:
	if Input.is_action_pressed("zoom_in"):
		position = _camera.get_screen_center_position()
	if Input.is_action_pressed("zoom_out"):
		position = _camera.get_screen_center_position()


func _process(_delta):
	get_input()


func _ready():
	var viewport_size := get_viewport_rect().size / 2
	_movement.limit_right = _camera.limit_right - viewport_size.x / _camera.zoom.x
	_movement.limit_left = _camera.limit_left + viewport_size.x / _camera.zoom.x
	_movement.limit_bottom = _camera.limit_bottom - viewport_size.y / _camera.zoom.y
	_movement.limit_top = _camera.limit_top + viewport_size.y / _camera.zoom.y
