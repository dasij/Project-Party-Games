extends TextureRect

export var draggable := true

onready var title = $Title
onready var description = $Description
onready var indication = $Indication

var card = null setget set_card

func set_card(new_card: Card):
	if card != null:
		card.disconnect("will_play_effect", self, "_on_Card_will_play_effect")
		card.disconnect("played_effect", self, "_on_Card_played_effect")
	card = new_card
	if new_card != null:
		card.connect("will_play_effect", self, "_on_Card_will_play_effect")
		card.connect("played_effect", self, "_on_Card_played_effect")
		show()
		# this occurs because this function can 
		# be executed before ready state
		if title != null and description != null:
			title.text = card.title
			description.text = card.description
	else:
		hide()
		# this occurs because this function can 
		# be executed before ready state
		if title != null and description != null:
			title.text = ""
			description.text = ""

func _ready():
	# call set function again after ready state
	# this way the labels are updated automatically
	# after creation and edition of the card_ui component
	set_card(card)

func _on_Card_will_play_effect():
	indication.color = Color.blue
	pass
	
func _on_Card_played_effect():
	indication.color = Color.transparent
	pass
