extends KinematicBody2D

onready var GlobalCamera := $Camera as Camera2D

export var speed := 200
var velocity := Vector2.ZERO
var active := false

func toggle(camera: Camera2D) -> void:
	if active:
		deactivate(camera)
	else:
		activate()

func activate() -> void:
	if GlobalCamera != null:
		GlobalCamera.make_current()
		self.set_process(true)
		active = true

func deactivate(camera: Camera2D) -> void:
	if GlobalCamera != null:
		GlobalCamera.current = false
		camera.make_current()
		self.set_process(false)
		active = false

func get_input() -> void:
	var viewport_size := get_viewport().size / 2
	
	velocity = Vector2.ZERO
	if Input.is_action_pressed('ui_right'):
		if position.x + viewport_size.x < GlobalCamera.limit_right:
			velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		if position.x - viewport_size.x > GlobalCamera.limit_left:
			velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		if position.y + viewport_size.y < GlobalCamera.limit_bottom:
			velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		if position.y - viewport_size.y > GlobalCamera.limit_top:
			velocity.y -= 1
	velocity = velocity.normalized() * speed
	
func _process(delta):
	get_input()
	velocity = move_and_slide(velocity)
