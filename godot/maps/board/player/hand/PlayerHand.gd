extends Node
class_name PlayerHand

var cards := []

func add_card(card: Card):
	if cards.size() <= 5:
		cards.append(card)
	else:
		print("limit exceeded")
	
