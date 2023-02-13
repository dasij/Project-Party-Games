extends Node
class_name Deck

signal added_to_deck(card, idx)
signal removed_from_deck(card, idx)
signal added_to_hand(card, idx)
signal removed_from_hand(card, idx)

var deck  := []
var hand  := [null, null, null, null, null] setget , get_hand

func get_hand() -> Array:
	var result := []
	for hand_card in hand:
		if hand_card != null:
			result.append(hand_card)
	return result

func reset_hand():
	hand = [null, null, null, null, null]

func add_card_to_deck(card: Card):
	deck.append(card)
	emit_signal("added_to_deck", card, deck.size() - 1)

func remove_card(card: Card):
	var deck_idx = deck.find(card)
	if deck_idx != -1:
		deck.remove(deck_idx)
		emit_signal("removed_from_deck", card, deck_idx)

func remove_card_from_hand(hand_idx):
	if hand_idx < hand.size() and hand_idx >= 0:
		var card = hand[hand_idx]
		deck.append(card)
		hand[hand_idx] = null
		emit_signal("added_to_deck", card, deck.size() - 1)
		emit_signal("removed_from_hand", card, hand_idx)

func change_hand_order(from_idx, to_idx):
	var aux = hand[from_idx]
	hand[from_idx] = hand[to_idx]
	hand[to_idx] = aux

func pick_card(card: Card, hand_idx: int):
	if hand_idx < hand.size() and hand_idx >= 0:
		var deck_idx = deck.find(card)
		if deck_idx != -1:
			deck.remove(deck_idx)
			hand[hand_idx] = card
			emit_signal("added_to_hand", card, hand_idx)
			emit_signal("removed_from_deck", card, deck_idx)
