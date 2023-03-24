class_name TopDownMovement
extends Node

@export var node_path: NodePath
@export var speed: float = 500
@export var limit_top: float = -10000000
@export var limit_bottom: float = 10000000
@export var limit_left: float = -10000000
@export var limit_right: float = 10000000


@onready var _node = get_node(node_path) as CharacterBody2D 


func activate() -> void:
	self.set_process(true)


func deactivate() -> void:
	self.set_process(false)


func get_input() -> Vector2:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		if _node.position.x < limit_right:
			velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		if _node.position.x > limit_left:
			velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		if _node.position.y < limit_bottom:
			velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		if _node.position.y > limit_top:
			velocity.y -= 1
	return velocity.normalized() * speed


func _process(_delta):
	var velocity = get_input()
	_node.velocity = velocity
	_node.move_and_slide()
