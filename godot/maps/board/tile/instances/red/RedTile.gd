@tool
extends Tile


func effect(board, player):
	player.score.sub_points -= 3
	TileEvent.emit_signal("record", "Red tile: %s lost 3 subpoints" % player.nick)
	await player.animate_rotation()
