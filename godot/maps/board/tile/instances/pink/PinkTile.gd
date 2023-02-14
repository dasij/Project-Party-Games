extends Tile

func effect(board, player):
	yield(player.animate_scale(), "completed")
	TileEvent.emit_signal("record", "Pink tile: %s move one tile" % player.nick)
	yield(player.set_actual_tile(self.next_tiles[0]), "completed")
	yield(player.actual_tile.play_effect(board, player), "completed")
