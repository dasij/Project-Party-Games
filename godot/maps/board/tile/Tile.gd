tool
extends Node2D
class_name Tile

export(Array, NodePath) var next_tiles_path = [] setget set_next_tiles_path
export var arrow_circle_radius := 40.0

var next_tiles: Array = []
var prev_tiles: Array = []
var tiles_ready: bool = false

onready var Arrows = $Arrows


func set_next_tiles_path(array):
	if array == null:
		next_tiles = []
		return

	if not tiles_ready:
		next_tiles_path = array
		return

	var result := []
	for node in array:
		if node != null:
			if node != "":
				node = get_node_or_null(node)
			else:
				node = null
		if node != null:
			result.append(node)
			node = node as Tile
			TileEvent.emit_signal("linked", self, node)
			if not "prev_tiles" in node:
				continue
			if not node.prev_tiles.has(self):
				node.prev_tiles.append(self)
	if next_tiles != null:
		for node in next_tiles:
			if node != null and not result.has(node):
				node.prev_tiles.erase(self)
				TileEvent.emit_signal("delinked", self, node)
	self.next_tiles = result
	self.update_arrows(self.next_tiles)
	next_tiles_path = array


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
	Arrows.show()
	var tile_idx_choosed = yield(TileEvent, "path_choosed")
	Arrows.hide()
	return self.next_tiles[tile_idx_choosed] as Tile


func get_arrow_for(tile):
	return Arrows.get_node_or_null(str(tile))


# function that removes and add arrows based on next_tiles array
# this is not written in a performatic way but considering we
# probably will not have a tile that has more than 5 `next_tiles`
# this should be ok
func update_arrows(tiles):
	if tiles.size() >= 2:
		for arrow in Arrows.get_children():
			var found = false
			for tile in tiles:
				if str(tile) == arrow.name:
					found = true
			if not found:
				Arrows.remove_child(arrow)
				arrow.queue_free()

		for i in range(tiles.size()):
			var tile = tiles[i]
			if get_arrow_for(tile) == null:
				var arrow = preload("res://maps/board/tile/arrow/Arrow.tscn").instance()
				arrow.init(i)
				arrow.name = str(tile)
				Arrows.add_child(arrow)
				arrow.set_owner(get_tree().get_edited_scene_root())
	else:
		for arrow in Arrows.get_children():
			Arrows.remove_child(arrow)
			arrow.queue_free()


#func add_arrow(tile):
#	if get_arrow_for(tile) == null:
#		var Arrow = preload("res://maps/board/tile/arrow/Arrow.tscn").instance().init(self, tile)
#		Arrow.name = str(tile)
#		Arrows.add_child(Arrow)
#
#
#func remove_arrow(tile):
#	var arrow = get_arrow_for(tile)
#	if arrow != null:
#		Arrows.remove_child(arrow)
#		arrow.queue_free()


func effect(board, player):
	pass


func play_effect(board, player):
	yield(effect(board, player), "completed")


func _to_string():
	return self.name


func _ready():
	if not Engine.editor_hint:
		Arrows.hide()
	TileEvent.connect("tiles_ready", self, "_on_Tile_tiles_ready")


func _on_Tile_tiles_ready():
	self.tiles_ready = true
