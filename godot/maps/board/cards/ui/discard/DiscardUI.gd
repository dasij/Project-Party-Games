extends Control

signal discarded

onready var Cards := $Cards
onready var Garbage := $Garbage
onready var DiscardLabel := $Label

var deck = null setget set_deck


func set_deck(new_deck):
	Cards.reset()
	if new_deck != null:
		new_deck.connect("removed_from_deck", self, "_on_Deck_removed_from_deck")
		if DiscardLabel != null:
			DiscardLabel.text = "Please discard %s card(s)" % str(new_deck.deck.size() - 5)
		if Cards != null:
			Cards.add_cards_to_ui(new_deck.deck)
	if deck != null:
		deck.disconnect("removed_from_deck", self, "_on_Deck_removed_from_deck")
	deck = new_deck


func _ready():
	set_deck(deck)
	Garbage.connect("discarded", self, "_on_Garbage_discarded")


func _on_Garbage_discarded(card):
	deck.remove_card(card)


func _on_Deck_removed_from_deck(_card: Card, idx: int):
	Util.delete_child(Cards, idx)
	yield(Garbage.animate(), "completed")
	if deck.deck.size() <= 5:
		emit_signal("discarded")
