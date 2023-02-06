extends Node2D
class_name Board

export var max_round: int = 12

onready var label_dado = $UI/Screen/Dado
onready var label_round = $UI/Screen/Round
onready var camera = $Camera2D

onready var players = $Players.get_children()
onready var tiles = $Tiles.get_children()

onready var score_ui = $UI/Screen/ScoreUI

onready var planning_ui := $UI/Screen/Phases/Planning
onready var play_ui := $UI/Screen/Phases/Play

signal round_started

func setup_game(players):
	var start_tile = $Tiles/Start as Tile
	
	var i := 0
	for player in players:
		var score_player_ui = preload("res://maps/board/player/score/ScorePlayerUI.tscn").instance()
		score_player_ui.set_anchors_preset(Control.PRESET_WIDE)
		var placeholder = score_ui.get_child(i) as Control
		placeholder.add_child(score_player_ui)
		score_player_ui.player = player
		i += 1
#		score_player_ui.connect()
		
	
	for player in players:
		player = player as BoardPlayer
		player.connect("walked", self, "_on_Player_walked")
		player.actual_tile = start_tile
	

func play_turn(player: BoardPlayer):
	play_phase(player)
	yield(player.play_turn(self), "completed")

func before_play_turn(player: BoardPlayer):
	give_player_random_card(player)
	give_player_random_card(player)
	give_player_random_card(player)
	yield(planning_phase(player), "completed")
	pass

func give_player_random_card(player: BoardPlayer):
	var random_card = CardsCollection.get_random_card()
	player.deck.add_card_to_deck(random_card)

func planning_phase(player: BoardPlayer):
	play_ui.hide()
	planning_ui.deck = player.deck
	planning_ui.show()
	yield(planning_ui, "pressed_play")
	
func play_phase(player: BoardPlayer):
	planning_ui.hide()
	play_ui.deck = player.deck
	play_ui.show()

func game_round(players):
	for player in players:
		player = player as BoardPlayer
		player.camera.make_current()
		yield(before_play_turn(player), "completed")
		yield(play_turn(player), "completed")
		yield(get_tree().create_timer(1), "timeout")

func _ready():
	connect("round_started", self, "_on_Board_round_started")
	
	setup_game(players)
	for round_i in max_round:
		emit_signal("round_started", round_i, max_round)
		yield(game_round(players), "completed")

func _on_Dice_playing_dice():
	label_dado.text = "Rolando dado"

func _on_Player_walked():
	label_dado.text = "Dado rolou\nAndando..."

func _on_Board_round_started(round_i, max_round):
	label_round.text = "Round %s/%s" % [round_i + 1, max_round]
