extends Node2D
class_name Board

export var max_round: int = 12

onready var GlobalCamera := $GlobalCamera

onready var LabelDado = $UI/Screen/Dado
onready var LabelRound = $UI/Screen/Round

onready var Players := $Players.get_children()

onready var Title = $UI/Screen/Title
onready var ScoreUI := $UI/Screen/ScoreUI

onready var Phases := $UI/Screen/Phases
onready var PlanningUI := $UI/Screen/Phases/Planning
onready var PlayUI := $UI/Screen/Phases/Play
onready var DiscardUI := $UI/Screen/Phases/DiscardUI

signal round_started

var state = {
	"actual_player": null
}

func setup_game(players):
	var start_tile = $Tiles/Start as Tile
	
	var i := 0
	for player in players:
		var score_player_ui = preload("res://maps/board/player/score/ScorePlayerUI.tscn").instance()
		score_player_ui.set_anchors_preset(Control.PRESET_WIDE)
		var placeholder = ScoreUI.get_child(i) as Control
		placeholder.add_child(score_player_ui)
		score_player_ui.player = player
		i += 1
#		score_player_ui.connect()
	
	for player in players:
		player = player as BoardPlayer
		player.connect("walked", self, "_on_Player_walked")
		player.actual_tile = start_tile

func transition_to_pre_turn(player: BoardPlayer) -> void:
	# move camera to player and deactivate GlobalCamera if its on
	GlobalCamera.deactivate(player.camera)
	# show phases ui
	Phases.visible = true
	# show title transitions
	var title := "Starting %s's turn" % player.nick
	yield(Title.play_title(title), "completed")

func pre_turn(player: BoardPlayer):
	give_player_random_card(player)
	give_player_random_card(player)
	give_player_random_card(player)
	give_player_random_card(player)
	yield(planning_phase(player), "completed")
	pass

func give_player_random_card(player: BoardPlayer):
	var random_card = CardsCollection.get_random_card()
	player.deck.add_card_to_deck(random_card)

func planning_phase(player: BoardPlayer):
	PlanningUI.deck = player.deck
	PlanningUI.show()
	yield(PlanningUI, "pressed_play")
	PlanningUI.hide()

func turn(player: BoardPlayer):
	PlayUI.show()
	PlayUI.deck = player.deck
	yield(player.play_turn(self), "completed")
	PlayUI.hide()

func transition_to_turn(player: BoardPlayer) -> void:
	yield(Title.play_title("Playing turn"), "completed")

func post_turn(player: BoardPlayer):
	yield(discard_phase(player), "completed")

func discard_phase(player):
	if player.deck.deck.size() > 5:
		DiscardUI.deck = player.deck
		DiscardUI.show()
		yield(DiscardUI, "discarded")
		DiscardUI.hide()
		DiscardUI.deck = null
	yield(get_tree(), "idle_frame")

func game_round(players):
	for player in players:
		player = player as BoardPlayer
		state.actual_player = player
		yield(transition_to_pre_turn(player), "completed")
		yield(pre_turn(player), "completed")
		yield(transition_to_turn(player), "completed")
		yield(turn(player), "completed")
		yield(post_turn(player), "completed")
		yield(get_tree().create_timer(1), "timeout")

func _input(event):
	if(event.is_action_pressed("ui_select") and not event.is_echo()):
		Phases.visible = not Phases.visible
		GlobalCamera.toggle(state.actual_player.camera)

func _ready():
	connect("round_started", self, "_on_Board_round_started")
	
	setup_game(Players)
	for round_i in max_round:
		emit_signal("round_started", round_i, max_round)
		yield(game_round(Players), "completed")

func _on_Dice_playing_dice():
	LabelDado.text = "Rolando dado"

func _on_Player_walked():
	LabelDado.text = "Dado rolou\nAndando..."

func _on_Board_round_started(round_i, max_round):
	LabelRound.text = "Round %s/%s" % [round_i + 1, max_round]
