extends Node

signal transition_to_signal(to: Node2D)
signal transition_from_to_signal(from: Node2D, to: Node2D)
signal transition_back_signal()
signal finished

var transitioning := false

func _transition_wrapper(f: Callable) -> void:
	transitioning = true
	f.call()
	await finished
	transitioning = false


func transition_to(to: Node2D) -> void:
	_transition_wrapper(
		func(): emit_signal("transition_to_signal", to)
	)


func transition_from_to(from: Node2D, to: Node2D) -> void:
	_transition_wrapper(
		func(): emit_signal("transition_from_to_signal", from, to)
	)


func transition_back() -> void:
	_transition_wrapper(
		func(): emit_signal("transition_back_signal")
	)
