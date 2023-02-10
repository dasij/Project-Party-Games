extends Control
class_name DraggableCard

onready var CardUI := $CardUI

var card = null setget set_card

func set_card(new_card):
	if CardUI != null:
		CardUI.set_card(card)
	card = new_card

func _ready():
	set_card(card)

func get_drag_data(_position):
	var data = {}
	data["card"] = card
	
	var control := create_dragged_card(CardUI.texture)
	set_drag_preview(control)
	
	return data

# utility function that can be called by any component
# that is trying to implement a draggable card (Slot for example)
static func create_dragged_card(texture) -> Control:
	var drag_texture = TextureRect.new()
	drag_texture.expand = true
	drag_texture.texture = texture
	drag_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	drag_texture.rect_size = Vector2(100,100)
	
	var control = Control.new()
	control.add_child(drag_texture)
	drag_texture.rect_position = -0.5 * drag_texture.rect_size
	
	return control
