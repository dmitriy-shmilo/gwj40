extends Control


onready var _fader = $"Fader"
onready var _cash_label = $"CashLabel"
onready var _title_label = $"TitleLabel"

func _ready() -> void:
	_cash_label.text = "$%.2f" % UserSaveData.current_cash
	_title_label.text = tr("ui_night_title") % UserSaveData.current_day


func _on_NextDayButton_pressed() -> void:
	_fader.fade_out()
	yield(_fader, "fade_out_completed")
	UserSaveData.current_day += 1
	UserSaveData.save_data()
	get_tree().change_scene("res://game_screen/game_screen.tscn")
