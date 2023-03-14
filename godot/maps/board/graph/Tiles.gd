@tool
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
		for tile_path in tile.next_tiles_path:
			if tile_path == null:
				continue
			var next_tile = tile.get_node(tile_path)
			if not next_tile.prev_tiles.has(self):
				next_tile.prev_tiles.append(self)


func _ready():
	TileEvent.emit_signal("tiles_ready")
	var tiles = self.get_children()
	for tile in tiles:
		tile.set_next_tiles_path(tile.next_tiles_path)
#	for tile in tiles:
#		print(tile)
#		print("\t%s" % str(tile.next_tiles))
#		print("\t%s" % str(tile.prev_tiles))

#	set_next_tiles(tiles)
#	set_prev_tiles(tiles)
