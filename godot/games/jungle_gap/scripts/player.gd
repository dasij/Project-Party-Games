extends KinematicBody2D
class_name JG_Player

onready var move_state: Node = get_node("States/Move")
onready var attack_state: Node = get_node("States/Attack")
onready var animation: Node = get_node("Animation")
onready var mira: Position2D = get_node("Mira")

onready var sprite: Sprite = get_node("Sprite")

var is_attacking: bool = false

func _physics_process(_delta: float) -> void:
	move_state.move()
	attack_state.attack()
	#move_mira()	
	move_mira_mouse()
	
func move_mira_mouse() -> void:
	mira.position = get_local_mouse_position()
		
func move_mira() -> void:
		var dir = Vector2(
			Input.get_action_strength("mira_down") - Input.get_action_strength("mira_up"),
			(Input.get_action_strength("mira_right") - Input.get_action_strength("mira_left"))
		)
		mira.position.x = mira.position.x + (dir.x * 10)
		mira.position.y = mira.position.y + (dir.y * 10)

func on_fall_body_entered(body):
	print(body)
	if body is DragonJG:
		return
	
	animation.play("fall")
	#queue_free()
	
	get_tree().reload_current_scene()
	
		
	#set_physics_process(true)
	
