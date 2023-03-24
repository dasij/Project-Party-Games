class_name Teleport
extends Card


func _init():
	title = "Teleport"
	description = "Teleport to another player tile"


func effect(board: Board, player: BoardPlayer) -> void:
	var players = board.players.filter(
		func(p): return p != player
	)
	var selected_player := await player.select_item(
		players
	) as BoardPlayer
	var selected_player_tile = selected_player.actual_tile
	await player.teleport_to_tile(selected_player_tile)
	await player.actual_tile.play_effect(board, player)

