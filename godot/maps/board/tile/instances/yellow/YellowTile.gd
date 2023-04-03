@tool
extends Tile

func effect(board, player):
	player.hp += 8
	TileEvent.emit_signal("record", "Blue tile: %s Gain HP" % player.nick)
	await player.animate_scale()
