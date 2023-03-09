extends Control

onready var health_bar = $HealthBar
onready var transition_bar = $HealthTransition
onready var animation := $Tween


func update_health(new_value):
	if new_value > health_bar.value:
		update_up(new_value)
	else:
		update_down(new_value)


func update_up(new_value):
	animation.interpolate_property(
		transition_bar,
		"value",
		transition_bar.value,
		new_value,
		1,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	animation.start()
	yield(animation, "tween_completed")
	health_bar.value = new_value


func update_down(new_value):
	health_bar.value = new_value
	animation.interpolate_property(
		transition_bar,
		"value",
		transition_bar.value,
		new_value,
		1,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	animation.start()
