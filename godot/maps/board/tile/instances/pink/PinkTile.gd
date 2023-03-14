@tool
extends Tile


func effect(board, player):
	await player.animate_scale()
	TileEvent.emit_signal("record", "Pink tile: %s move one tile" % player.nick)
	await player.move()
	await player.actual_tile.play_effect(board, player)
