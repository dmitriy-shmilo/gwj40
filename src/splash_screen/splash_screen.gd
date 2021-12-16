extends Control

onready var _fader: Fader = $"Fader"

func _ready() -> void:
	yield(_fader, "fade_in_completed")
	Settings.load_settings()
	UserSaveData.load_data()
	_fader.fade_out()
	yield(_fader, "fade_out_completed")
	# TODO: set to title screen
	get_tree().change_scene("res://day_screen/day_screen.tscn")
