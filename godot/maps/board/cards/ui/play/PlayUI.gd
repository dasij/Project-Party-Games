extends Control

@onready var Cards := $Cards

var deck = null : set = set_deck


func set_deck(new_deck):
	Cards.reset()
	if new_deck != null:
		if Cards != null:
			Cards.add_cards_to_ui(new_deck.hand, false)
	deck = new_deck


func _ready():
	set_deck(deck)
