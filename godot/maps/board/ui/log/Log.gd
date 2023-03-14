extends RichTextLabel

var logs := []
var max_logs := 20


func clear_last_logs():
	var logs_size := logs.size()
	if logs_size > max_logs:
		for i in logs_size - max_logs:
			logs.pop_front()
		write_logs(logs)


# this function replaces the logs written
func write_logs(logs: Array):
	self.text = ""
	for stored_log in logs:
		self.text += stored_log + "\n"


func _ready():
	TileEvent.connect("record",Callable(self,"_on_Event_logged"))
	CardEvent.connect("record",Callable(self,"_on_Event_logged"))
	BoardEvent.connect("turn_ended",Callable(self,"_on_BoardEvent_turn_ended"))


func _on_Event_logged(text: String) -> void:
	logs.append(text)
	self.text += text + "\n"


func _on_BoardEvent_turn_ended():
	clear_last_logs()
