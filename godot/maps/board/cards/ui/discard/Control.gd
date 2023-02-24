extends PanelContainer

signal discarded(card)


func can_drop_data(_position, data):
	if "card" in data:
		return data.card != null
	return false


func drop_data(_position, data):
	emit_signal("discarded", data.card)


func animate():
	var animation := $Tween as Tween
	if animation != null:
		animation.interpolate_property(
			self, "rect_scale", rect_scale, rect_scale * 1.25, 0.5, Tween.TRANS_LINEAR
		)
		animation.start()
		yield(animation, "tween_completed")
		animation.interpolate_property(
			self, "rect_scale", rect_scale, rect_scale / 1.25, 0.5, Tween.TRANS_LINEAR
		)
		animation.start()
		yield(animation, "tween_completed")
