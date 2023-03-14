@tool
extends Node2D
class_name Tile

enum TILE_TYPE { NORMAL, GRAVEYARD }

@export var next_tiles_path = [] : set = set_next_tiles_path # (Array, NodePath)
@export var arrow_circle_radius := 40.0

var next_tiles: Array[Tile] = []
var prev_tiles: Array[Tile] = []
var tiles_ready: bool = false
var tile_type = TILE_TYPE.NORMAL

@onready var Arrows = $Arrows


func set_next_tiles_path(array):
	if array == null:
		next_tiles = []
		return

	if not tiles_ready:
		next_tiles_path = array
		return

	var result := [] as Array[Tile]
	for node in array:
		if node != null:
			node = get_node_or_null(node) as Tile
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


func get_next_tile() -> Tile:
	var next_size := self.next_tiles.size()
	if next_size > 0:
		if next_size == 1:
			return next_tiles[0] as Tile
		else:
			var choosed_tile = await choose_path()
			return choosed_tile
	return null
	


func choose_path() -> Tile:
	Arrows.show()
	var tile_idx_choosed = await TileEvent.path_choosed
	Arrows.hide()
	return self.next_tiles[tile_idx_choosed] as Tile


func get_arrow_for(tile: Tile) -> Arrow:
	return Arrows.get_node_or_null(str(tile)) as Arrow


# function that removes and add arrows based on next_tiles array
# this is not written in a performatic way but considering we
# probably will not have a tile that has more than 5 `next_tiles`
# this should be ok
func update_arrows(tiles: Array[Tile]) -> void:
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
				var arrow = preload("res://maps/board/tile/arrow/Arrow.tscn").instantiate()
				arrow.init(i)
				arrow.name = str(tile)
				Arrows.add_child(arrow)
				arrow.set_owner(get_tree().get_edited_scene_root())
	else:
		for arrow in Arrows.get_children():
			Arrows.remove_child(arrow)
			arrow.queue_free()


func pre_turn_effect(board: Board, player: BoardPlayer):
	pass


func play_pre_turn_effect(board: Board, player: BoardPlayer):
	await pre_turn_effect(board, player)


func effect(board: Board, player: BoardPlayer):
	pass


func play_effect(board: Board, player: BoardPlayer) -> void:
	await effect(board, player)


func _to_string() -> String:
	return str(self.name)


func _ready():
	if not Engine.is_editor_hint():
		Arrows.hide()
	TileEvent.connect("tiles_ready",Callable(self,"_on_Tile_tiles_ready"))


func _on_Tile_tiles_ready() -> void:
	self.tiles_ready = true


static func is_graveyard(tile: Tile) -> bool:
	return tile.tile_type == TILE_TYPE.GRAVEYARD
