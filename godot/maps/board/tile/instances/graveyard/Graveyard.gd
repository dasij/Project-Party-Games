tool
extends Tile


func pre_turn_effect(board, player):
	# restores player
	yield(player.restore(), "completed")
	CardEvent.emit_signal("record", "%s rises again" % player.nick)
	# move player out of graveyard
	# (goes to next tile)
	yield(player.move(), "completed")


func _init():
	._init()
	self.tile_type = TILE_TYPE.GRAVEYARD
