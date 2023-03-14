extends Card
class_name Suicide


func _init():
	title = "Suicide"
	description = "Kill yourself"


func effect(board, player):
	await player.set_hp(0)
