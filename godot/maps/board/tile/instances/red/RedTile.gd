extends Tile

func effect(board, player):
	player.score.sub_points -= 3
	TileEvent.emit_signal("record", "Red tile: %s lost 3 subpoints" % player.nick)
	yield(player.animate_rotation(), "completed")

