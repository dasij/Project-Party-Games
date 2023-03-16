@tool
extends Tile
class_name PortalTile

var state := PortalController.State.INACTIVE : set = set_state

func set_state(new_state):
	match new_state:
		PortalController.State.INACTIVE:
			$Sprite2D.texture = preload("res://assets/tiles/icon_portal_inactive.png")
		PortalController.State.BLUE:
			$Sprite2D.texture = preload("res://assets/tiles/icon_portal_blue.png")
		PortalController.State.ORANGE:
			$Sprite2D.texture = preload("res://assets/tiles/icon_portal_orange.png")
	state = new_state


func effect(board: Board, player: BoardPlayer):
	match state:
		PortalController.State.INACTIVE:
			PortalController.set_portal(self)
		PortalController.State.BLUE:
			player.teleport_to_tile(PortalController.get_orange())
		PortalController.State.ORANGE:
			player.teleport_to_tile(PortalController.get_blue())


func _ready():
	super._ready()
	PortalController.add_portal(self)
