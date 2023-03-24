class_name ZoomController
extends Node

@export var camera_path: NodePath
@export var zoom_speed: float = 0.01
@export var zoom_min: float = 1
@export var zoom_max: float = 4

@onready var _camera := get_node(camera_path) as Camera2D

func activate():
	set_process(true)


func deactivate():
	set_process(false)


func get_camera():
	return _camera


func get_input():
	if Input.is_action_pressed("zoom_in"):
		var zoom := _camera.zoom.x
		var new_zoom := min(zoom_max, zoom + zoom_speed) as float
		_camera.zoom = Vector2(new_zoom, new_zoom)
	if Input.is_action_pressed("zoom_out"):
		var zoom := _camera.zoom.x
		var new_zoom := max(zoom_min, zoom - zoom_speed) as float
		_camera.zoom = Vector2(new_zoom, new_zoom)


func _process(_delta):
	get_input()


func _ready():
	_camera.align()
