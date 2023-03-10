@tool
extends Path2D

var from_tile = null
var to_tile = null


func init(from_tile, to_tile):
	self.link(from_tile, to_tile)
	self.curve = Curve2D.new()
	self.curve.add_point(from_tile.position)
	self.curve.add_point(to_tile.position)
	return self


func link(from_tile, to_tile):
	self.from_tile = from_tile
	self.to_tile = to_tile


func _process(_delta):
	if Engine.is_editor_hint():
		if from_tile != null:
			self.curve.set_point_position(0, from_tile.position)
		if to_tile != null:
			var count = self.curve.get_point_count()
			self.curve.set_point_position(count - 1, to_tile.position)


func _ready():
	if not Engine.is_editor_hint():
		set_process(false)
		self.hide()
