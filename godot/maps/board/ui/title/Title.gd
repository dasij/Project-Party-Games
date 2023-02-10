extends Control

func play_title(title_text: String, animation := "Fade") -> void:
	var TitleLabel := $Label as Label
	var TitleAnimation := $AnimationPlayer as AnimationPlayer
	
	if TitleLabel != null and TitleAnimation != null:
		TitleLabel.text = title_text
		TitleAnimation.play("Fade")
		yield(TitleAnimation, "animation_finished")
	else:
		# TODO: see a way to remove this
		yield(get_tree(), "idle_frame")
