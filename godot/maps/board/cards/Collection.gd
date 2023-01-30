extends Node
class_name CardsCollection

const cards = [
	Dice,
	SubPoint
]

static func get_random_card():
	var cards_size = cards.size()
	var idx := 0
	if cards_size > 0:
		idx = Util.randi_from_range(0, cards.size() - 1)
	return cards[idx]
