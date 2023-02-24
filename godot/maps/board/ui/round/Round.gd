extends Label

func _ready():
	BoardEvent.connect("round_started", self, "_on_Board_round_started")
	
func _on_Board_round_started(round_i, max_round):
	self.text = "Round %s/%s" % [round_i + 1, max_round]
