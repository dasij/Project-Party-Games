extends Control
class_name Slot

signal removed_card(card) # removed card
signal added_card(card, idx) # added index
signal changed_order(idx_from, idx_to)
signal changed_card(old_card, new_card, idx_hand)

onready var slot_empty: TextureRect = $Empty
onready var slot_card: TextureRect = $Card
onready var remove_button: Button = $Card/Remove

var card = null setget set_card
var number := 1

func set_card(new_card):
	if new_card == null:
		slot_empty.show()
		slot_card.hide()
		slot_card.card = null
	else:
		slot_card.show()
		slot_empty.hide()
		slot_card.card = new_card
	card = new_card

func get_drag_data(_position):
	var data = {}
	data["card"] = card
	data["from"] = self
	
	var control := DraggableCard.create_dragged_card(slot_card.texture)
	set_drag_preview(control)
	
	return data

func can_drop_data(_position, data):
	return "card" in data and data.card != null

func drop_data(_position, data):
	if "from" in data and data.from != null:
		var FromSlot = data.from
		FromSlot.card = self.card
		emit_signal("changed_order", FromSlot.number, number)
	elif self.card != null:
		emit_signal("changed_card", self.card, data.card, number)
	else:
		emit_signal("added_card", data.card, number)
	self.card = data.card

func reset():
	self.card = null

func _ready():
	remove_button.connect("pressed", self, "_on_Remove_pressed")

func _on_Remove_pressed():
	emit_signal("removed_card", card)
	self.card = null
