extends Node2D

export var max_round: int = 12

onready var label_dado = $UI/Fixed/Dado
onready var label_round = $UI/Fixed/Round
onready var camera = $Camera2D

signal round_started

func setup_game(players):
	var start_tile = $Tiles/Start as Tile
	for player in players:
		player = player as BoardPlayer
		player.connect("playing_dice", self, "_on_Player_playing_dice")
		player.connect("walked", self, "_on_Player_walked")
		player.actual_tile = start_tile
	

func _on_Player_playing_dice():
	label_dado.text = "Rolando dado"

func _on_Player_walked(i, number_of_tiles):
	label_dado.text = "Dado rolou %s\nAndando %s" % [number_of_tiles, i + 1]

func _on_Board_round_started(round_i, max_round):
	label_round.text = "Round %s/%s" % [round_i + 1, max_round]

func play_turn(player: BoardPlayer):
	yield(player.play_turn(), "completed")
	
func game_round(players):
	for player in players:
		player = player as BoardPlayer
		yield(play_turn(player), "completed")
		yield(get_tree().create_timer(1), "timeout")
	

func _ready():
	connect("round_started", self, "_on_Board_round_started")
	
	var players = $Players.get_children()
	setup_game(players)
	for round_i in max_round:
		emit_signal("round_started", round_i, max_round)
		yield(game_round(players), "completed")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
