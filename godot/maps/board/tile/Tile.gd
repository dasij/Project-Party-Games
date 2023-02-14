tool
extends Node2D
class_name Tile

export(Array, NodePath) var next_tiles_path = [];
export(Array, NodePath) var prev_tiles_path = [];

var next_tiles: Array = [];
var prev_tiles: Array = [];

func effect(board, player):
	pass

func play_effect(board, player):
	yield(effect(board, player), "completed")
