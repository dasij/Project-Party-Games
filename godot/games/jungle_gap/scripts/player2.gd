extends KinematicBody2D
class_name JG_Player2

onready var move_state: Node = get_node("States/Move")
onready var attack_state: Node = get_node("States/Attack")
onready var animation: Node = get_node("Animation")


onready var sprite: Sprite = get_node("Sprite")

var is_attacking: bool = false

func _physics_process(_delta: float) -> void:
	#move_state.move()
	#attack_state.attack()
	pass


func on_fall_body_entered(body):
	#print(body)
	
	if body.get_name() == "Player2":
		return
	
	animation.play("fall")
	#queue_free()
	
	#get_tree().reload_current_scene()
	
