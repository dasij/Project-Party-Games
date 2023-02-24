extends Tile


func effect(board, player):
	var random_card = CardsCollection.get_random_card()
	player.deck.add_card_to_deck(random_card)
	TileEvent.emit_signal(
		"record", "Black tile: %s gained %s card" % [player.nick, str(random_card)]
	)
	yield(player.animate_scale(), "completed")
