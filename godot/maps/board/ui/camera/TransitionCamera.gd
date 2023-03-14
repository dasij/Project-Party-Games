extends RigidBody2D

@export var speed := 700

@onready var TransitionCamera := $TransitionCamera


func transition_to(active_node: Node2D, next_node: Node2D) -> void:
	if TransitionCamera != null:
		var tweener := create_tween().set_trans(Tween.TRANS_SINE)
		var from_position = active_node.position
		var from_zoom = active_node.get_camera().zoom
		var next_camera = next_node.get_camera()

		self.position = from_position
		TransitionCamera.zoom = from_zoom

		var duration = (from_position.distance_to(next_node.position)) / speed

		TransitionCamera.make_current()
		tweener.tween_method(
			func(t): self.position = from_position.lerp(next_node.position, t),
			0.0,
			1.0,
			duration
		)
		tweener.parallel().tween_method(
			func(t): TransitionCamera.zoom = from_zoom.lerp(next_camera.zoom, t),
			0.0,
			1.0,
			duration
		)
		await tweener.finished
		next_node.get_camera().make_current()
