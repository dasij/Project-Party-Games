extends RigidBody2D

@onready var TransitionCamera := $TransitionCamera
@onready var animation := create_tween()

@export var speed := 700


func transition_to(active_node: Node2D, next_node: Node2D) -> void:
	if TransitionCamera != null:
		var from_position = active_node.position
		var from_zoom = active_node.get_camera().zoom
		var next_camera = next_node.get_camera()

		self.position = from_position
		TransitionCamera.zoom = from_zoom

		var duration = (from_position.distance_to(next_node.position)) / speed

		TransitionCamera.make_current()
		animation.tween_method(
			func(t): self.position = next_node.position,
			0,
			1,
			duration
		).set_trans(Tween.TRANS_SINE)
		animation.parallel().tween_method(
			func(t): TransitionCamera.zoom = next_camera.zoom,
			0,
			1,
			duration
		).set_trans(Tween.TRANS_SINE)
		await animation.finished
		next_node.get_camera().make_current()
