extends Node
class_name JG_AttackState

@export(NodePath) onready var player = get_node(player) as CharacterBody2D
@export(NodePath) onready var project_spawner = get_node(project_spawner) as Marker2D
@export var fire_project: PackedScene
@export(NodePath) onready var animation = get_node(animation) as AnimationPlayer

func attack() -> void:
	if Input.is_action_just_pressed("ui_select") or Input.is_action_just_pressed("attack"):
		#player.is_attacking = true
		animation.play("fire")

func spawn_fire() -> void:
	var fire_direction: Vector2 = (player.get_global_mouse_position() - player.global_position).normalized()
	var fire = fire_project.instantiate()
	get_tree().root.call_deferred("add_child", fire)
	fire.global_position = project_spawner.global_position
	fire.direction = fire_direction
