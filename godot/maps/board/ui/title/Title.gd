extends Control

func play_title(title_text: String, animation := "Fade") -> void:
	var TitleLabel := $Label as Label
	var TitleAnimation := $AnimationPlayer as AnimationPlayer

	if TitleLabel != null and TitleAnimation != null:
		TitleLabel.text = title_text
		TitleAnimation.play("Fade")
		await TitleAnimation.animation_finished
