@tool
extends Node2D

var undirected_graph = {}

@onready var paths = $Paths
@onready var tiles = $Tiles


func get_tiles() -> Array:
	return undirected_graph.keys() as Array


func add_undirected_edge(from_tile: Tile, to_tile: Tile) -> void:
	add_directed_edge(from_tile, to_tile)
	add_directed_edge(to_tile, from_tile)


func add_directed_edge(from_tile: Tile, to_tile: Tile) -> void:
	if not from_tile in self.undirected_graph:
		self.undirected_graph[from_tile] = [to_tile]
	else:
		self.undirected_graph[from_tile].append(to_tile)


func bfs(start_node: Tile, condition: Callable, directed_graph := false) -> Variant:
	# TODO: decide which graph take
	var graph = self.undirected_graph
	var queue := []
	var marked := {}

	marked[start_node] = true
	queue.append(start_node)

	while not queue.is_empty():
		var node = queue.pop_front()
		if condition.call(node):
			return node
		for neighbor in graph[node]:
			if not neighbor in marked:
				marked[neighbor] = true
				queue.append(neighbor)
	return null


func get_tiles_from_path_name(path: TilePath) -> Array[Tile]:
	var tile_names = path.name.split("-")
	var from_tile = tiles.get_node(tile_names[0])
	var to_tile = tiles.get_node(tile_names[1])
	return [from_tile, to_tile]


func get_path_name(from_tile: Tile, to_tile: Tile) -> String:
	return "%s-%s" % [from_tile.name, to_tile.name]


func get_path_node(from_tile: Tile, to_tile: Tile) -> TilePath:
	return paths.get_node(get_path_name(from_tile, to_tile))


func link_paths() -> void:
	if Engine.is_editor_hint():
		for path in paths.get_children():
			var tiles_linked = get_tiles_from_path_name(path)
			var from_tile = tiles_linked[0]
			var to_tile = tiles_linked[1]
			path.link(from_tile, to_tile)


func create_graph() -> void:
	for path in paths.get_children():
		var tiles_linked = get_tiles_from_path_name(path)
		var from_tile = tiles_linked[0]
		var to_tile = tiles_linked[1]
		self.add_undirected_edge(from_tile, to_tile)


func _ready():
	if Engine.is_editor_hint():
		TileEvent.connect("linked",Callable(self,"_on_Tile_linked").bind(),CONNECT_PERSIST)
		TileEvent.connect("delinked",Callable(self,"_on_Tile_delinked").bind(),CONNECT_PERSIST)
		link_paths()
	create_graph()


func _on_Tile_linked(from_tile: Tile, to_tile: Tile):
	if Engine.is_editor_hint():
		self.add_undirected_edge(from_tile, to_tile)
		var path_name = get_path_name(from_tile, to_tile)
		if paths.get_node_or_null(path_name) == null:
			var LinkPath = preload("res://maps/board/tile/path/Path.tscn").instantiate().init(from_tile, to_tile)
			LinkPath.name = path_name
			paths.add_child(LinkPath)
			LinkPath.set_owner(get_tree().get_edited_scene_root())


func _on_Tile_delinked(from_tile: Tile, to_tile: Tile):
	if Engine.is_editor_hint():
		var name = get_path_name(from_tile, to_tile)
		var node = paths.get_node_or_null(name)
		if node != null:
			paths.remove_child(node)
