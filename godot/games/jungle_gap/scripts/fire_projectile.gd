extends Area2D
class_name FireProjectile

var distancia_perc: int = 0

var already_destroyed: bool = false

var direction: Vector2 = Vector2.ZERO

export(int) var damage_base
export(int) var move_speed

func _process(delta) -> void:
	translate(direction * move_speed * delta)
	scale *= .98
	distancia_perc += 1
	damage_base = damage_base * distancia_perc
	
func kill() -> void:
	already_destroyed = true
	queue_free()

func on_screen_exited():
	if not already_destroyed:
		kill()

func on_body_entered(body):
	kill()
