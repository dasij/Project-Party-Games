extends Node2D

class_name Card

enum CARD_TYPE {
	DICE,
	NORMAL,
	RARE
}

export(CARD_TYPE) var card_type = CARD_TYPE.DICE
export(String) var title = "";
export(String) var description = "";

func effect(board):
	pass
