extends RigidBody2D

onready var TransitionCamera := $TransitionCamera
onready var TweenCamera := $Tween

func transition_to(active_node: Node2D, next_node: Node2D) -> void:
	if TransitionCamera != null:
		var from_position = active_node.position
		var from_zoom = active_node.get_camera().zoom
		var to_zoom = next_node.get_camera().zoom
		self.position = from_position
		TransitionCamera.zoom = from_zoom
		TransitionCamera.make_current()
		TweenCamera.follow_property(self, "position", from_position, next_node, "position", 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		TweenCamera.interpolate_property(TransitionCamera, "zoom", from_zoom, to_zoom, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		TweenCamera.start()
		print_debug(self.position)
		yield(TweenCamera, "tween_completed")
		next_node.get_camera().make_current()

func set_position(new_pos: Vector2) -> void:
	print_debug(new_pos)
	self.position = new_pos
