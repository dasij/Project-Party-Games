extends TextureButton
class_name Arrow

var from_tile = null
var to_tile = null

# warning-ignore:shadowed_variable
func init(from_tile, to_tile):
	self.connect("pressed", self, "_on_Arrow_pressed")
	self.from_tile = from_tile
	self.to_tile = to_tile
	
	var direction = from_tile.position.direction_to(to_tile.position)
	var angle = from_tile.position.angle_to_point(to_tile.position)
	
	self.rect_rotation += rad2deg(angle + PI)
	self.rect_position += direction * from_tile.arrow_circle_radius
	
	return self

func _on_Arrow_pressed():
	TileEvent.emit_signal("path_choosed", to_tile)

