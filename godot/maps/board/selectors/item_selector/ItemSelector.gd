class_name ItemSelector
extends Node

signal item_selected

var _items: Array = []
var _selected_index: int = 0 : set = _set_selected_index


func _set_selected_index(new_index: int) -> void:
	var new_value = new_index % _items.size()
	_selected_index = new_value
	TransitionEvent.transition_to(_items[new_value])
	


func init(items) -> ItemSelector:
	_items = items
	TransitionEvent.transition_to((_items[0]))
	BoardEvent.emit_signal("entered_selection")
	return self


func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		_selected_index += 1
	elif event.is_action_pressed("ui_down"):
		_selected_index -= 1
	elif event.is_action_pressed("confirm"):
		emit_signal("item_selected", _items[_selected_index])
		BoardEvent.emit_signal("finished_selection")

