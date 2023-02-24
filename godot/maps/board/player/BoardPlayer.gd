extends Node2D
class_name BoardPlayer

signal do_action

onready var animation: Tween = $Tween
onready var camera: Camera2D = $Camera2D

export var nick: String = ""
export var speed := 250

var actual_tile: Tile = null setget set_actual_tile
var deck  := Deck.new()
var score := Score.new()

func get_camera() -> Camera2D:
	return camera

func set_actual_tile(new_tile: Tile):
	if actual_tile == null:
		self.position = new_tile.position
		actual_tile = new_tile
	elif new_tile == null:
		actual_tile = actual_tile
	else:
		actual_tile = new_tile
		

func move():
	var next_tile = yield(actual_tile.get_next_tile(), "completed") as Tile
	yield(move_to_tile(next_tile), "completed")

func move_to_tile(new_tile: Tile):
	var new_position = new_tile.position
	var old_position = actual_tile.position
	
	var distance := new_tile.position.distance_to(actual_tile.position)
	var duration := distance / self.speed
	
	animation.interpolate_property(
		self, 
		'position', 
		old_position, 
		new_position, 
		duration, Tween.TRANS_SINE, Tween.EASE_IN)
	animation.start()
	yield(animation, "tween_completed")
	set_actual_tile(new_tile)

func play_turn(board):
	for card in deck.hand:
		yield(self, "do_action")
		yield(card.play_effect(board, self), "completed")
	deck.reset_hand()

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
