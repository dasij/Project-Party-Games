extends Tile

func effect(board, player):
	yield(player.animate_scale(), "completed")
	TileEvent.emit_signal("record", "Pink tile: %s move one tile" % player.nick)
	yield(player.move(), "completed")
	yield(player.actual_tile.play_effect(board, player), "completed")
