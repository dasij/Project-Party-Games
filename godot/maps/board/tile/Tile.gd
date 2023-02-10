tool
extends Node2D
class_name Tile

export(bool) var decoration = false;

export(Array, NodePath) var next_tiles_path = [];
export(Array, NodePath) var prev_tiles_path = [];

var next_tiles: Array = [];
var prev_tiles: Array = [];

# TODO: join this function with `set_prev_tiles`
# This function translates the NodePath objects from `next_tile_paths`
# to `next_tiles` that are actual nodes
#func set_next_tiles(node_paths):
#	if node_paths == null:
#		next_tiles = []
#		return
#	var result := []
#
#	for node_path in node_paths:
#		# get node from node_path if it exists
#		var node = null
#		if node_path != null and node_path != "":
#			node = get_node(node_path)
#
#		# appends it on result array
#		result.append(node)
#
#		# set prev_tiles in next node
#		if node != null:
#			if not "prev_tiles" in node:
#				continue
#			if node.prev_tiles == null:
#				node.prev_tiles = [self]
#			elif not node.prev_tiles.has(self):
#				node.prev_tiles.append(self)
#
##	if next_tiles != null:
##		for node in next_tiles:
##			# clear prev if node was remove from next nodes array
##			if node != null and not result.has(node) and "prev_tiles" in node:
##				node.prev_tiles.erase(self)
#
#	next_tiles = result
	

# TODO: join this function with `get_prev_tiles`
#func get_next_tiles():
#	if next_tiles == null:
#		return
#
#	var result := []
#
#	for node in next_tiles:
#		if node != null:
#			result.append(get_path_to(node))
#		else:
#			result.append(null)
#
#	return result
#
#func set_prev_tiles(node_paths):
#	# Suppress errors on the command line when opening th project the first
#	# time the nodes are loaded in the _ready function.
#	if not has_node(".."):
#		prev_tiles = node_paths
#		return
#	#
#	if node_paths == null:
#		prev_tiles = []
#		return
#	var result := []
#
#	for node_path in node_paths:
#		# get node from node_path if it exists
#		var node = null
#		if node_path != null and node_path != "":
#			node = get_node(node_path)
#
#		# appends it on result array
#		result.append(node)
#
#		# set next_tiles in prev node
#		if node != null:
#			if not "next_tiles" in node:
#				continue
#			if node.next_tiles == null:
#				node.next_tiles = [self]
#			elif not node.next_tiles.has(self):
#				node.next_tiles.append(self)
#
##	if prev_tiles != null:
##		for node in prev_tiles:
##			# clear next if node was remove from prev nodes array
##			if node != null and not result.has(node) and "next_tiles" in node:
##				node.next_tiles.erase(self)
#
#	prev_tiles = result
#
#func get_prev_tiles():
#	if prev_tiles == null:
#		return
#
#	var result := []
#
#	for node in prev_tiles:
#		if node != null:
#			result.append(get_path_to(node))
#		else:
#			result.append(null)
#
#	return result

enum NODE_TYPES {
	BLUE,
	RED,
	PINK,
	BLACK
}

export(NODE_TYPES) var node_type: int = NODE_TYPES.BLUE setget set_type
# Receives a type and set it to `node_type` variable
func set_type(type):
	if type != null:
		node_type = type

	# Check if it has already been added to the tree to prevent errors from
	# flooding the console when opening it in the editor.
	if has_node("Sprite"):
		set_node_material(node_type)

# Sets sprite based on node type
# warning-ignore:shadowed_variable
func set_node_material(node_type):
	match node_type:
		NODE_TYPES.RED:
			$Sprite.texture = preload("res://icon_red.png")
		NODE_TYPES.BLUE:
			$Sprite.texture = preload("res://icon.png")
		NODE_TYPES.PINK:
			$Sprite.texture = preload("res://icon_pink.png")
		NODE_TYPES.BLACK:
			$Sprite.texture = preload("res://icon_black.png")
		

# TODO
# Renders the linking arrows.
func draw_linking_lines() -> void:
	pass
	# if Engine.editor_hint:
		# Only the node model should be rotated/scaled
		# Because the root node is being edited, we can't just forward
		# Those transformation to the node model and keep the rest normal.
		# If we'd try, it won't be saved as it's an instanced scene
		# for node in next_tiles:
			# if node == null:
				# continue
			# print(node.global_position)
			# $Line2D.add_point(global_position)
			# $Line2D.add_point(node.global_position)
			


#func _process(delta):
#	draw_linking_lines()

func play_effect(board, player):
	match node_type:
		NODE_TYPES.RED:
			yield(play_red_effect(board, player), "completed")
		NODE_TYPES.BLUE:
			yield(play_blue_effect(board, player), "completed")
		NODE_TYPES.PINK:
			yield(play_pink_effect(board, player), "completed")
		NODE_TYPES.BLACK:
			yield(play_black_effect(board, player), "completed")
		

func play_red_effect(board, player):
	player.score.sub_points -= 3
	yield(player.animate_rotation(), "completed")

func play_pink_effect(board, player):
	yield(player.set_actual_tile(self.next_tiles[0]), "completed")
	yield(player.actual_tile.play_effect(board, player), "completed")

func play_black_effect(board, player):
	var random_card = CardsCollection.get_random_card()
	player.deck.add_card_to_deck(random_card)
	yield(player.animate_scale(), "completed")

func play_blue_effect(board, player):
	player.score.sub_points += 3
	yield(player.animate_scale(), "completed")


func _ready():
#	set_next_tiles(next_tiles_path)
#	set_prev_tiles(prev_tiles_path)
	set_node_material(node_type)
