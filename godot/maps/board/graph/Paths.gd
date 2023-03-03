tool
extends Node2D


func add_path(from_tile, to_tile):
	var path = Path2D.new() as Path2D
	var curve = Curve2D.new()
	curve.add_point(from_tile.position, to_tile.position)
	path.curve = curve
	self.add_child(path)
