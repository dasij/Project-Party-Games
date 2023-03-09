extends Card
class_name Suicide


func _init():
	title = "Suicide"
	description = "Kill yourself"


func effect(board, player):
	yield(player.set_hp(0), "completed")
