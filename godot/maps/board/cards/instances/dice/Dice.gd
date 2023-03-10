extends Card
class_name Dice

var max_tiles := 6
var min_tiles := 1


func _init():
	title = "Dice"
	description = "Roll a dice of six sides"


func roll_dice() -> int:
	return Util.randi_from_range(min_tiles, max_tiles)


func effect(board, player):
	var number_of_tiles = roll_dice()
	# TODO: move text to function
	CardEvent.emit_signal("record", "%s rolled %s on the dice" % [player.nick, number_of_tiles])
	for i in number_of_tiles:
		CardEvent.emit_signal(
			"record", "%s is walking %s of %s" % [player.nick, i + 1, number_of_tiles]
		)
		await player.move()
	await player.actual_tile.play_effect(board, player)
