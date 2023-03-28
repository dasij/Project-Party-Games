@tool
extends Tile

func effect(board, player):
	#player.hp -= player.hp * 0.25
	player.hp -= 8
	TileEvent.emit_signal("record", "Green tile: %s Loss HP" % player.nick)
	await player.animate_scale()
