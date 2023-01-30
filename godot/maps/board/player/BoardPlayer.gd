extends Node2D
class_name BoardPlayer

signal scored_points(points)
signal scored_sub_points(sub_points)
signal walked
signal do_action

onready var animation: Tween = $Tween
onready var camera: Camera2D = $Camera2D

var player_name: String = ""
var actual_tile: Tile = null setget set_actual_tile
var hand := PlayerHand.new()
var score := Score.new()

func set_actual_tile(new_tile: Tile):
	if actual_tile == null:
		actual_tile = new_tile
	elif new_tile == null:
		actual_tile = actual_tile
	else:
		yield(move_to_tile(new_tile), "completed")
		actual_tile = new_tile
		
	

func move_to_tile(new_tile: Tile):
	var new_position = new_tile.position
	var old_position = actual_tile.position
	animation.interpolate_property(
		self, 
		'position', 
		old_position, 
		new_position, 
		1, Tween.TRANS_SINE, Tween.EASE_IN)
	animation.start()
	yield(animation, "tween_completed")
	emit_signal("walked")

func play_turn(board):
	camera.current = true
	for card in hand.cards:
		yield(self, "do_action")
		yield(card.play_effect(board, self), "completed")
	camera.current = false

func _input(event):
	if(event.is_action_pressed("ui_accept") and not event.is_echo()):
		emit_signal("do_action")

func animate_scale():
	animation.interpolate_property(
		self, 
		"scale",
		scale, 
		scale * 2,
		0.5
	)
	animation.start()
	yield(animation, "tween_completed")
	animation.interpolate_property(
		self, 
		"scale",
		scale, 
		scale / 2,
		0.5
	)
	animation.start()
	yield(animation, "tween_completed")
	

func animate_rotation():
	animation.interpolate_property(
		self, 
		"rotation_degrees",
		rotation_degrees, 
		rotation_degrees + 360,
		1
	)
	animation.start()
	yield(animation, "tween_completed")

func _ready():
	score.connect("scored_points", self, "_on_Score_scored_points")
	score.connect("scored_sub_points", self, "_on_Score_scored_sub_points")

func _on_Score_scored_points(points):
	emit_signal("scored_points", points)

func _on_Score_scored_sub_points(sub_points):
	emit_signal("scored_sub_points", sub_points)
