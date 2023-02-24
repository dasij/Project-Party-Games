extends Control

onready var play_button = $PlayButton


func _ready():
	play_button.connect("pressed", self, "start_game")


func start_game():
	get_tree().change_scene("res://maps/board/Board.tscn")
