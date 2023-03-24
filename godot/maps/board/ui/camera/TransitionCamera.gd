extends Node2D

@export var speed := 700

var _previous_node: Node2D
var _active_node: Node2D
var _tweener: Tween

@onready var _transition_camera = $Camera

func transition_from_to(active_node: Node2D, next_node: Node2D) -> void:
	if active_node == null:
		self.position = next_node.global_position
		_active_node = next_node
		next_node.get_camera().make_current()
		return
	
	var from_position = active_node.global_position
	if _tweener != null and _tweener.is_running():
		from_position = self.position
		_tweener.kill()
	
	_tweener = create_tween().set_trans(Tween.TRANS_SINE)
	
	var from_zoom = active_node.get_camera().zoom
	var next_camera = next_node.get_camera()
	
	_transition_camera.zoom = from_zoom

	var duration = (from_position.distance_to(next_node.global_position)) / speed

	_transition_camera.make_current()
	_tweener.tween_method(
		func(t): self.position = from_position.lerp(next_node.global_position, t),
		0.0,
		1.0,
		duration
	)
	_tweener.parallel().tween_method(
		func(t): _transition_camera.zoom = from_zoom.lerp(next_camera.zoom, t),
		0.0,
		1.0,
		duration
	)
	_previous_node = active_node
	_active_node = next_node
	await _tweener.finished
	next_node.get_camera().make_current()
	TransitionEvent.emit_signal("finished")


func transition_to(next_node: Node2D) -> void:
	await transition_from_to(_active_node, next_node)


func transition_back() -> void:
	await transition_to(_previous_node)


func _ready():
	TransitionEvent.connect("transition_from_to_signal", Callable(self, "transition_from_to"))
	TransitionEvent.connect("transition_to_signal", Callable(self, "transition_to"))
	TransitionEvent.connect("transition_back_signal", Callable(self, "transition_back"))
