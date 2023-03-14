extends Control

@onready var play_button = $PlayButton


func _ready():
	play_button.connect("pressed",Callable(self,"start_game"))


func start_game():
	get_tree().change_scene_to_file("res://maps/board/Board.tscn")
