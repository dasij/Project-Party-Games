extends Tile

func effect(board, player):
	player.score.sub_points += 3
	TileEvent.emit_signal("record", "Blue tile: %s gained 3 subpoints" % player.nick)
	yield(player.animate_scale(), "completed")
