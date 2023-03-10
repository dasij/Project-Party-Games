extends Control

@onready var points_label = $Back/Points
@onready var sub_points_label = $Back/SubPoints
@onready var health_bar := $Back/HealthBar

var player = null : set = set_player


func init(player):
	set_player(player)
	return self


func set_player(new_player):
	if player != null:
		player.score.disconnect("scored_points",Callable(self,"_on_Player_scored_point"))
		player.score.disconnect("scored_sub_points",Callable(self,"_on_Player_scored_sub_point"))
		player.disconnect("changed_hp",Callable(self,"_on_Player_changed_hp"))
	if new_player != null:
		new_player.score.connect("scored_points",Callable(self,"_on_Player_scored_point"))
		new_player.score.connect("scored_sub_points",Callable(self,"_on_Player_scored_sub_point"))
		new_player.connect("changed_hp",Callable(self,"_on_Player_changed_hp"))
	player = new_player


func _on_Player_scored_point(points):
	points_label.text = str(points)


func _on_Player_scored_sub_point(sub_points):
	sub_points_label.text = str(sub_points)


func _on_Player_changed_hp(new_hp):
	# checks if health bar is initialized
	if health_bar != null:
		health_bar.update_health(new_hp)
