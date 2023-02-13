extends Node2D

class_name Card

signal will_play_effect
signal played_effect

enum CARD_TYPE {
	DICE,
	NORMAL,
	RARE
}

export(CARD_TYPE) var card_type = CARD_TYPE.DICE
export(String) var title = "";
export(String) var description = "";

func _to_string():
	return self.title

func record(board, player):
	return "%s played %s" % [player.nick, title]

func effect(board, player):
	pass

func play_effect(board, player):
	emit_signal("will_play_effect")
	CardEvent.emit_signal("will_play_effect")
	CardEvent.emit_signal("record", record(board, player))
	yield(effect(board, player), "completed")
	CardEvent.emit_signal("played_effect")
	emit_signal("played_effect")
