extends Control


onready var _fader = $"Fader"

func _on_NextDayButton_pressed() -> void:
	_fader.fade_out()
	yield(_fader, "fade_out_completed")
	get_tree().change_scene("res://game_screen/game_screen.tscn")
