@tool
extends Control
class_name Slot

signal removed_card(card)  # removed card
signal added_card(card, idx)  # added card on index idx
signal changed_order(idx_from, idx_to)  # changed order from idx_from to idx_to
signal changed_card(old_card, new_card, idx)  # changed card in idx

@onready var SlotEmpty: TextureRect = $Empty
@onready var SlotCard: TextureRect = $Card
@onready var RemoveButton: Button = $Card/Remove

var slot_card = null : set = set_slot_card
var number := 1


func set_slot_card(new_card):
	slot_card = new_card
	if new_card == null:
		SlotEmpty.show()
		SlotCard.hide()
		SlotCard.set_card(null)
	else:
		SlotCard.show()
		SlotEmpty.hide()
		SlotCard.set_card(new_card)


func _get_drag_data(_position):
	var data = {}
	data["card"] = slot_card
	data["from"] = self

	var control := DraggableCard.create_dragged_card(SlotCard.texture)
	set_drag_preview(control)

	return data


func _can_drop_data(_position, data):
	return "card" in data and data.card != null


func _drop_data(_position, data):
	if "from" in data and data.from != null:
		var FromSlot = data.from
		FromSlot.slot_card = self.slot_card
		emit_signal("changed_order", FromSlot.number, number)
	elif self.slot_card != null:
		emit_signal("changed_card", self.slot_card, data.card, number)
	else:
		emit_signal("added_card", data.card, number)
	self.slot_card = data.card


func reset():
	self.slot_card = null


func _ready():
	RemoveButton.connect("pressed",Callable(self,"_on_Remove_pressed"))


func _on_Remove_pressed():
	emit_signal("removed_card", slot_card)
	self.slot_card = null
