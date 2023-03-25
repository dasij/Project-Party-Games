class_name TileSelector
extends CharacterBody2D

signal tile_selected(tile: Tile)

@onready var _area_selection := $Area2D as Area2D
@onready var _camera := $BaseCamera

func get_camera():
	return _camera


func _input(event):
	if event.is_action_pressed("confirm"):
		var areas := _area_selection.get_overlapping_areas()
		if areas.is_empty():
			return
		var tile = areas[0].get_parent() as Tile
		if not tile.teleportable:
			return
		emit_signal("tile_selected", tile)
		BoardEvent.emit_signal("finished_selection")


func _ready():
	BoardEvent.emit_signal("entered_selection")
