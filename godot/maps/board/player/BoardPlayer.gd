extends Node2D
class_name BoardPlayer

# TODO: put this on the dice card
signal playing_dice
signal walked

onready var animation: Tween = $Tween
onready var camera: Camera2D = $Camera2D

var player_name: String = ""
var actual_tile: Tile = null setget set_actual_tile

func set_actual_tile(new_tile: Tile):
	if actual_tile == null:
		actual_tile = new_tile
	elif new_tile == null:
		actual_tile = actual_tile
	else:
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
		actual_tile = new_tile
	

# TODO: put this on the dice card
# generate a random number between initial and final values
# both values are inclusive
func randi_from_range(initial: int, final: int) -> int:
	return (randi() % (final - initial + 1)) + initial

# TODO: put this on the dice card
func roll_dice() -> int:
	return randi_from_range(1, 6)

signal walk
func _input(event):
	if(event.is_action_pressed("ui_right") and not event.is_echo()):
		emit_signal("walk")

func play_turn():
	camera.current = true
	if actual_tile.next_tiles.size() > 0:
		
		yield(self, "walk")
		emit_signal("playing_dice")
		yield(get_tree().create_timer(1), "timeout")
		var number_of_tiles = roll_dice()
		for i in number_of_tiles:
			emit_signal("walked", i, number_of_tiles)
			yield(set_actual_tile(actual_tile.next_tiles[0]), "completed")
		camera.current = false

