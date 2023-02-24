extends HBoxContainer


func reset():
	Util.delete_children(self)


func add_cards_to_ui(cards: Array, draggable := true):
	for card in cards:
		add_card_to_ui(card, draggable)


func add_card_to_ui(card: Card, draggable := true):
	var CardUI = null
	if draggable:
		CardUI = preload("res://maps/board/cards/ui/draggable/DraggableCard.tscn")
	else:
		CardUI = preload("res://maps/board/cards/ui/CardUI.tscn")
	CardUI = CardUI.instance()
	# TODO: this can be done in a better? (without setting min_size)
	CardUI.rect_min_size = Vector2(105, 149)
	CardUI.card = card
	self.add_child(CardUI)
