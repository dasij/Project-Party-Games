extends Control

onready var points_label = $Points
onready var sub_points_label = $SubPoints
var player = null setget set_player

func set_player(new_player):
	if player != null:
		player.disconnect("scored_points", self, "_on_Player_scored_point")
		player.disconnect("scored_sub_points", self, "_on_Player_scored_sub_point")
	if new_player != null:
		new_player.connect("scored_points", self, "_on_Player_scored_point")
		new_player.connect("scored_sub_points", self, "_on_Player_scored_sub_point")
	player = new_player

func _on_Player_scored_point(points):
	points_label.text = "POINTS: %s" % points

func _on_Player_scored_sub_point(sub_points):
	sub_points_label.text = "SUBPOINTS: %s" % sub_points
