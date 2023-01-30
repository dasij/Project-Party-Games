extends Node
class_name Score

signal scored_points(points)
signal scored_sub_points(sub_points)

var points := 0 setget set_points
var sub_points := 0 setget set_sub_points
var minigames_won := 0

func set_points(new_points: int):
	if new_points <= 0:
		points = 0
	else:
		points = new_points
	emit_signal("scored_points", points)

func set_sub_points(new_points: int):
	if new_points <= 0:
		sub_points = 0
	else:
		sub_points = new_points
	emit_signal("scored_sub_points", sub_points)
