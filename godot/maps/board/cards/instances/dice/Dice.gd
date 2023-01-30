extends Card
class_name Dice

signal playing_dice

var max_tiles := 6
var min_tiles := 1

func _init():
	title = "Dice"
	description = "Roll a dice of six sides"

func roll_dice() -> int:
	return Util.randi_from_range(min_tiles, max_tiles)

func effect(board, player):
	connect("playing_dice", board, "_on_Dice_playing_dice")
	emit_signal("playing_dice")
	var number_of_tiles = roll_dice()
	for i in number_of_tiles:
		if player.actual_tile.next_tiles.size() > 0:
			var next_tile = player.actual_tile.next_tiles[0]
			yield(player.set_actual_tile(next_tile), "completed")
	yield(player.actual_tile.play_effect(board, player), "completed")
	disconnect("playing_dice", board, "_on_Dice_playing_dice")
	
	
