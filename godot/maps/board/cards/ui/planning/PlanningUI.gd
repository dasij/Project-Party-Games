extends Control

signal pressed_play

onready var slots := $Turn/Control/Slots
onready var cards := $Cards
onready var play_button := $Turn/Control/PlayButton

var deck = null setget set_deck

func set_deck(new_deck):
	reset()
	if new_deck != null:
		new_deck.connect("added_to_deck", self, "_on_Deck_added_to_deck")
		new_deck.connect("removed_from_deck", self, "_on_Deck_removed_from_deck")
		new_deck.connect("added_to_hand", self, "_on_Deck_added_to_hand")
		new_deck.connect("removed_from_hand", self, "_on_Deck_removed_from_hand")
		if cards != null:
			cards.add_cards_to_ui(new_deck.deck)
	deck = new_deck

# this functions tells how the UI is reseted
func reset():
	# remove all cards from deck
	if cards != null:
		cards.reset()
	
	# reset all hand slots
	for slot in slots.get_children():
		slot.reset()
	
	# if there is a deck remove all its connections and put him as null
	if deck != null:
		deck = deck as Deck
		# TODO: better way to do this?
		deck.disconnect("added_to_deck", self, "_on_Deck_added_to_deck")
		deck.disconnect("removed_from_deck", self, "_on_Deck_removed_from_deck")
		deck.disconnect("added_to_hand", self, "_on_Deck_added_to_hand")
		deck.disconnect("removed_from_hand", self, "_on_Deck_removed_from_hand")
		deck = null

func _ready():
	_ready_connects()
	
func _ready_connects():
	play_button.connect("pressed", self, "_on_Play_pressed")
	for slot in slots.get_children():
		slot.connect("removed_card", self, "_on_Slot_removed_card")
		slot.connect("added_card", self, "_on_Slot_added_card")
		slot.connect("changed_order", self, "_on_Slot_changed_order")
		slot.connect("changed_card", self, "_on_Slot_changed_card")

func _on_Slot_removed_card(_card, hand_idx: int):
	deck.remove_card_from_hand(hand_idx)
	
func _on_Slot_added_card(card, hand_idx: int):
	deck.pick_card(card, hand_idx)
	
func _on_Slot_changed_order(from_idx, to_idx):
	deck.change_hand_order(from_idx, to_idx)

func _on_Slot_changed_card(_old_card, new_card, hand_idx):
	deck.remove_card_from_hand(hand_idx)
	deck.pick_card(new_card, hand_idx)

func _on_Play_pressed():
	emit_signal("pressed_play")
	
func _on_Deck_added_to_deck(card: Card, _idx: int):
	cards.add_card_to_ui(card)

func _on_Deck_removed_from_deck(_card: Card, idx: int):
	Util.delete_child(cards, idx)

func _on_Deck_added_to_hand(_card: Card, _idx: int):
	play_button.set_disabled(false)
	pass

func _on_Deck_removed_from_hand(_card: Card, _idx: int):
	if deck.hand.size() == 0:
		play_button.set_disabled(true)
	pass

