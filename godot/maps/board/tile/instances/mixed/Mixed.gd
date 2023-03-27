@tool
class_name Mixed
extends Tile

@export var tiles: Array[GDScript] = []
@export var chances: Array[float] = []


func effect(board, player):
	var drawn_chance = randi() % 100
	for i in range(chances.size()):
		if drawn_chance < chances[i]:
			var node = tiles[i].new() as Tile
			await node.effect(board, player)
			node.queue_free()
			return


func _ready():
	super._ready()
	assert(tiles.size() == chances.size())
