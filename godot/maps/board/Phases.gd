extends Control


func _ready():
	BoardEvent.connect("turn_started", self, "_on_BoardEvent_turn_started")
	CameraEvent.connect("changed_to_global", self, "_on_CameraEvent_changed_to_global")
	CameraEvent.connect("changed_to_player", self, "_on_CameraEvent_changed_to_player")


func _on_BoardEvent_turn_started(player: BoardPlayer) -> void:
	self.visible = true


func _on_CameraEvent_changed_to_global() -> void:
	self.visible = false


func _on_CameraEvent_changed_to_player() -> void:
	self.visible = true
