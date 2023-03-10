@tool
extends TextureButton
class_name Arrow

@export var to_tile_idx = 0


func init(to_tile_idx):
	self.to_tile_idx = to_tile_idx
	return self


func _ready():
	self.connect("pressed",Callable(self,"_on_Arrow_pressed"))


func _on_Arrow_pressed():
	TileEvent.emit_signal("path_choosed", to_tile_idx)
