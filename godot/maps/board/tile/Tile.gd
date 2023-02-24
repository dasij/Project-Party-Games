tool
extends Node2D
class_name Tile

export var arrow_circle_radius := 40.0

export(Array, NodePath) var next_tiles_path = [];
export(Array, NodePath) var prev_tiles_path = [];

var next_tiles: Array = [];
var prev_tiles: Array = [];

func get_next_tile():
	var next_size := self.next_tiles.size()
	if next_size > 0:
		if next_size == 1:
			yield(get_tree(), "idle_frame")
			return next_tiles[0]
		else:
			var choosed_tile = yield(choose_path(), "completed")
			return choosed_tile

func choose_path():
	add_arrows()
	var tile_choosed = yield(TileEvent, "path_choosed")
	remove_arrows()
	return tile_choosed as Tile

func add_arrows():
	for tile in self.next_tiles:
		var Arrow = preload("res://maps/board/tile/arrow/Arrow.tscn").instance().init(self, tile)
		self.add_child(Arrow)

func remove_arrows():
	for child in get_children():
		if child is Arrow:
			child = child as Arrow
			self.remove_child(child)
			child.queue_free()

func effect(board, player):
	pass

func play_effect(board, player):
	yield(effect(board, player), "completed")
