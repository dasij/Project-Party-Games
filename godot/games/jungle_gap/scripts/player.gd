extends CharacterBody2D
class_name JG_Player

@onready var move_state: Node = get_node("States/Move")
@onready var attack_state: Node = get_node("States/Attack")

@onready var sprite: Sprite2D = get_node("Sprite2D")

var is_attacking: bool = false

func _physics_process(_delta: float) -> void:
	move_state.move()
	attack_state.attack()
