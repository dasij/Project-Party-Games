@tool
extends Tile

func pre_turn_effect(board, player):
	# restores player
	await player.restore()
	CardEvent.emit_signal("record", "%s rises again" % player.nick)
	# move player out of graveyard
	# (goes to next tile)
	await player.move()


func _init():
	super._init()
	self.tile_type = TILE_TYPE.GRAVEYARD
	self.teleportable = false
