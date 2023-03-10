extends PanelContainer

signal discarded(card)


func _can_drop_data(_position, data):
	if "card" in data:
		return data.card != null
	return false


func _drop_data(_position, data):
	emit_signal("discarded", data.card)


func animate():
	var tweener := create_tween().set_trans(Tween.TRANS_LINEAR)
	tweener.tween_property(
		self, "scale", scale * 1.25, 0.5
	)
	tweener.tween_property(
		self, "scale", scale / 1.25, 0.5
	)
	await tweener.finished
