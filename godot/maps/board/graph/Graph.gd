tool
extends Node2D

onready var paths = $Paths
onready var tiles = $Tiles


func get_tiles_from_path_name(path):
	var tile_names = path.name.split("-")
	var from_tile = tiles.get_node(tile_names[0])
	var to_tile = tiles.get_node(tile_names[1])
	return [from_tile, to_tile]


func get_path_name(from_tile, to_tile) -> String:
	return "%s-%s" % [from_tile.name, to_tile.name]


func get_path_node(from_tile, to_tile):
	return paths.get_node(get_path_name(from_tile, to_tile))


func link_paths():
	if Engine.editor_hint:
		for path in paths.get_children():
			var tiles_linked = get_tiles_from_path_name(path)
			var from_tile = tiles_linked[0]
			var to_tile = tiles_linked[1]
			path.link(from_tile, to_tile)


func _ready():
	if Engine.editor_hint:
		TileEvent.connect("linked", self, "_on_Tile_linked", [], CONNECT_PERSIST)
		TileEvent.connect("delinked", self, "_on_Tile_delinked", [], CONNECT_PERSIST)
		link_paths()


func _on_Tile_linked(from_tile, to_tile):
	if Engine.editor_hint:
		var path_name = get_path_name(from_tile, to_tile)
		if paths.get_node_or_null(path_name) == null:
			var LinkPath = preload("res://maps/board/tile/path/Path.tscn").instance().init(from_tile, to_tile)
			LinkPath.name = path_name
			paths.add_child(LinkPath)
			LinkPath.set_owner(get_tree().get_edited_scene_root())


func _on_Tile_delinked(from_tile, to_tile):
	if Engine.editor_hint:
		var name = get_path_name(from_tile, to_tile)
		var node = paths.get_node_or_null(name)
		if node != null:
			paths.remove_child(node)
