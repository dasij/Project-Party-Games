tool
extends Control

signal removed_card(card, idx)
signal added_card(card, idx)
signal changed_order(from_idx, to_idx)
signal changed_card(old_card, new_card, idx_hand)

export var number := 0 setget set_number

onready var NumberLabel := $HBoxContainer/Number
onready var Slot := $Slot


func set_number(new_number):
	number = new_number
	if NumberLabel != null:
		NumberLabel.text = str(new_number + 1)
	if Slot != null:
		Slot.number = number


func reset():
	Slot.reset()


func _ready():
	set_number(number)
	Slot.connect("removed_card", self, "_on_Slot_removed_card")
	Slot.connect("added_card", self, "_on_Slot_added_card")
	Slot.connect("changed_order", self, "_on_Slot_changed_order")
	Slot.connect("changed_card", self, "_on_Slot_changed_card")


func _on_Slot_removed_card(card):
	emit_signal("removed_card", card, number)


func _on_Slot_added_card(card, _idx):
	emit_signal("added_card", card, number)


func _on_Slot_changed_order(from_idx, to_idx):
	emit_signal("changed_order", from_idx, to_idx)


func _on_Slot_changed_card(old_card, new_card, idx):
	emit_signal("changed_card", old_card, new_card, idx)
