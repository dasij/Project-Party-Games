extends Area2D
class_name HitBoxDragon

var on_hit: bool = false
var on_death: bool = false

export(int) var health

var max_health_value: int


export(NodePath) onready var health_bar = get_node(health_bar) as TextureProgress

func _ready():
	max_health_value = health
	health_bar.init_bar(health)

func on_area_entered(area):
	health -= 10
	health_bar.update_value(health)
	


