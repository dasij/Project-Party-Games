extends Node
class_name JG_MoveState

var velocity: Vector2

export(int) var walk_speek

export(NodePath) onready var player = get_node(player) as KinematicBody2D

func move() -> void:
	if player.is_attacking:
		return
		
	velocity = get_direction() * walk_speek
	player.move_and_slide(velocity)
	
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		(Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")) / 2
	)
	#conferir se, divide por 2 o y no isometrico ou normaliza o total  
