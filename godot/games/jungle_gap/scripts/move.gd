extends Node
class_name JG_MoveState

var velocity: Vector2

@export var walk_speek: int

@export(NodePath) onready var player = get_node(player) as CharacterBody2D

func move() -> void:
	if player.is_attacking:
		return
		
	velocity = get_direction() * walk_speek
	player.set_velocity(velocity)
	player.move_and_slide()
	player.velocity
	
func get_direction() -> Vector2:
#	if Input.is_mouse_button_pressed(2):
		var dir = Vector2(
			Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
			(Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")) / 2
		)
		var mouse = player.get_global_mouse_position()
		var play = player.global_position
		var dir2 = (mouse - play).normalized()
		return dir
#	else:
#		return Vector2.ZERO	
	#conferir se, divide por 2 o y no isometrico ou normaliza o total  
