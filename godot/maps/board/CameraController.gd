extends Node

var _on_global := false
var _allow_global := true

@onready var _global_camera := $GlobalCamera

func _input(event):
	if event.is_action_pressed("ui_select"):
		if _on_global:
			_on_global = false
			TransitionEvent.transition_back()
			CameraEvent.emit_signal("changed_to_player")
			_global_camera.deactivate()
		elif _allow_global:
			_on_global = true
			TransitionEvent.transition_to(_global_camera)
			CameraEvent.emit_signal("changed_to_global")
			_global_camera.activate()


func _ready():
	BoardEvent.connect("entered_selection", func(): _allow_global = false)
	BoardEvent.connect("finished_selection", func(): _allow_global = true)
