extends Node2D

onready var GlobalCamera := $GlobalCamera
onready var TransitionCamera := $TransitionCamera

# possible states for the camera
enum CAMERA {
	GLOBAL,
	PLAYER
}

# the main camera starts on the player
var camera_state = CAMERA.PLAYER 

# tracks the camera that is showed on the screen
var active_node = null setget set_active_node

# the player of the turn must be saved here, 
# so we can back to him, after any camera change
var turn_player = null

# state variable to know whether the control 
# is transitioning or not
var transitioning := false


func set_active_node(new_node):
	if active_node == null:
		new_node.get_camera().make_current()
	elif new_node == null:
		active_node.get_camera().current = false
	else:
		transitioning = true
		yield(TransitionCamera.transition_to(active_node, new_node), "completed")
		transitioning = false
	active_node = new_node

func _input(event):
	if event.is_action_pressed("ui_select") and not transitioning:
		match camera_state:
			# if camera is in global state change 
			# it to the player
			CAMERA.GLOBAL:
				GlobalCamera.deactivate()
				yield(set_active_node(turn_player), "completed")
				camera_state = CAMERA.PLAYER
				CameraEvent.emit_signal("changed_to_player")
			# if camera is in player state change 
			# it to the global
			CAMERA.PLAYER:
				GlobalCamera.activate()
				yield(set_active_node(GlobalCamera), "completed")
				camera_state = CAMERA.GLOBAL
				CameraEvent.emit_signal("changed_to_global")

func _ready():
	BoardEvent.connect("turn_started", self, "_on_BoardEvent_turn_started")

func _on_BoardEvent_turn_started(player: BoardPlayer):
	GlobalCamera.deactivate()
	set_active_node(player)
	camera_state = CAMERA.PLAYER
	turn_player = player

