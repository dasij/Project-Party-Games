extends Card
class_name WhereAmI

func _init():
	title = "Where am I?"
	description = "Teleport to a random space"


func effect(board: Board, player: BoardPlayer) -> void:
	var tiles = board.graph.get_tiles().filter(
		func(tile): return tile.teleportable
	)
	var random_tile = Util.array_get_random(tiles)
	CardEvent.emit_signal("record", "%s is teleporting" % player.nick)
	await player.teleport_to_tile(random_tile)
	await player.actual_tile.play_effect(board, player)
