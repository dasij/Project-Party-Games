extends Card
class_name SubPoint


func _init():
	card_type = CARD_TYPE.NORMAL
	title = "SubPoints"
	description = "Give sub points"


func effect(board, player):
	player.score.sub_points += 5
	yield(player.animate_scale(), "completed")
