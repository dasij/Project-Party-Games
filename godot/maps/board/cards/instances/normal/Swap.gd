class_name Swap
extends Card


func _init():
	title = "Swap"
	description = "Swap places with another player"


func effect(board: Board, player: BoardPlayer) -> void:
	var players = board.players.filter(
		func(p): return p != player
	)
	var selected_player := await player.select_item(
		players
	) as BoardPlayer
	var selected_player_tile = selected_player.actual_tile
	await selected_player.teleport_to_tile(player.actual_tile)
	await player.teleport_to_tile(selected_player_tile)
	await player.actual_tile.play_effect(board, player)

