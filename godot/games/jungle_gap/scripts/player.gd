extends KinematicBody2D
class_name JG_Player

onready var move_state: Node = get_node("States/Move")
onready var attack_state: Node = get_node("States/Attack")

onready var sprite: Sprite = get_node("Sprite")

var is_attacking: bool = false

func _physics_process(_delta: float) -> void:
	move_state.move()
	
