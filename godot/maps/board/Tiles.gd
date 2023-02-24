extends Node2D


func set_next_tiles(tiles):
	for tile in tiles:
		var result := []
		tile = tile as Tile
		for tile_path in tile.next_tiles_path:
			if tile_path == null:
				continue

			result.append(tile.get_node(tile_path))

		tile.next_tiles = result


func set_prev_tiles(tiles):
	for tile in tiles:
		var result := []
		tile = tile as Tile
		for tile_path in tile.prev_tiles_path:
			if tile_path == null:
				continue

			result.append(tile.get_node(tile_path))

		tile.prev_tiles = result


func _ready():
	var tiles = self.get_children()
	set_next_tiles(tiles)
	set_prev_tiles(tiles)
