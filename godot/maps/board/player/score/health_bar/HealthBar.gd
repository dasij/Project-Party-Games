extends Control

@onready var health_bar = $HealthBar
@onready var transition_bar = $HealthTransition

func update_health(new_value):
	if new_value > health_bar.value:
		update_up(new_value)
	else:
		update_down(new_value)


func update_up(new_value):
	var tweener := create_tween()
	tweener.tween_property(
		transition_bar,
		"value",
		new_value,
		1,
	)
	await tweener.finished
	health_bar.value = new_value


func update_down(new_value):
	health_bar.value = new_value
	var tweener := create_tween()
	tweener.tween_property(
		transition_bar,
		"value",
		new_value,
		1,
	)
