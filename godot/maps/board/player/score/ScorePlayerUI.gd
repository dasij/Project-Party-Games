extends Control

onready var points_label = $Back/Points
onready var sub_points_label = $Back/SubPoints
var player = null setget set_player

func init(player):
	set_player(player)
	return self

func set_player(new_player):
	if player != null:
		player.score.disconnect("scored_points", self, "_on_Player_scored_point")
		player.score.disconnect("scored_sub_points", self, "_on_Player_scored_sub_point")
	if new_player != null:
		new_player.score.connect("scored_points", self, "_on_Player_scored_point")
		new_player.score.connect("scored_sub_points", self, "_on_Player_scored_sub_point")
	player = new_player

func _on_Player_scored_point(points):
	points_label.text = str(points)

func _on_Player_scored_sub_point(sub_points):
	sub_points_label.text = str(sub_points)
