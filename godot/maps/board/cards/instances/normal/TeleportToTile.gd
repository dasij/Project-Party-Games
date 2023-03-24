extends Card
class_name TeleportToTile


func _init():
	title = "TeleportToTile"
	description = "Teleport the player to a selected tile"


func effect(board: Board, player: BoardPlayer) -> void:
	var tile := await player.select_tile() as Tile
	await player.teleport_to_tile(tile)
	await player.actual_tile.play_effect(board, player)
