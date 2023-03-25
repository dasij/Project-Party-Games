extends Node

var _chances_base := {
	basic = 45,
	rare = 80,
	broken = 95,
	legendary = 100
}

var cards = {
#	water = {
#		basic = [Dice],
#		rare = [Dice],
#		broken = [Dice],
#		legendary = [Dice],
#	},
	any = {
		basic = [Dice, SubPoint, WhereAmI],
		rare = [Teleport, Suicide],
		broken = [TeleportToTile],
		legendary = [Swap],
	}
}

func get_random_card(pools := [] as Array[String], chances := _chances_base):
	pools.append("any")
	var chance := randi() % 100
	for arity in chances.keys():
		if chance < chances[arity]:
			var cards = _filter_cards_by_arity(pools, arity) as Array[Card]
			var card_type = Util.array_get_random(cards)
			return card_type.new() as Card


func _filter_cards_by_arity(pools: Array[String], arity: String) -> Array:
	return pools.map(
		func(pool): return cards[pool][arity]
	).reduce(func(a, b): return a + b, [])
