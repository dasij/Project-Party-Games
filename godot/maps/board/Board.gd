extends Node2D
class_name Board

export var max_round: int = 12

onready var Players := $Players.get_children()

onready var Title = $UI/Screen/Title
onready var ScoreUI := $UI/Screen/ScoreUI

onready var PlanningUI := $UI/Screen/Phases/Planning
onready var PlayUI := $UI/Screen/Phases/Play
onready var DiscardUI := $UI/Screen/Phases/DiscardUI

var state = {"actual_player": null}


func setup_game(players):
	var start_tile = $Tiles/Start as Tile

	var i := 0
	for player in players:
		var score_player_ui = preload("res://maps/board/player/score/ScorePlayerUI.tscn").instance().init(player)
		score_player_ui.set_anchors_preset(Control.PRESET_WIDE)
		var placeholder = ScoreUI.get_child(i) as Control
		placeholder.add_child(score_player_ui)
		i += 1
#		score_player_ui.connect()

	for player in players:
		player = player as BoardPlayer
		player.actual_tile = start_tile


func transition_to_pre_turn(player: BoardPlayer) -> void:
	# show title transitions
	var title := "Starting %s's turn" % player.nick
	yield(Title.play_title(title), "completed")


func pre_turn(player: BoardPlayer):
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
		BoardEvent.emit_signal("turn_started", player)
		yield(transition_to_pre_turn(player), "completed")
		yield(pre_turn(player), "completed")
		yield(transition_to_turn(player), "completed")
		yield(turn(player), "completed")
		yield(post_turn(player), "completed")
		yield(get_tree().create_timer(1), "timeout")
		BoardEvent.emit_signal("turn_ended")


func _ready():
	setup_game(Players)

	for round_i in max_round:
		BoardEvent.emit_signal("round_started", round_i, max_round)
		yield(game_round(Players), "completed")
