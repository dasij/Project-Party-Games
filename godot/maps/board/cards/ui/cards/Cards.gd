extends HBoxContainer

func reset():
	Util.delete_children(self)

func add_cards_to_ui(cards: Array):
	for card in cards:
		add_card_to_ui(card)

func add_card_to_ui(card: Card):
	var CardUI = preload("res://maps/board/cards/ui/draggable/DraggableCard.tscn").instance()
	# TODO: this can be done in a better? (without setting min_size)
	CardUI.rect_min_size = Vector2(105,149)
	CardUI.card = card
	self.add_child(CardUI)
