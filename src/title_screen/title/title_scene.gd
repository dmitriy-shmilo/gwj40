extends Control
class_name TitleScene

onready var _quit_button = $"QuitButton"

func _ready():
	_quit_button.visible = not OS.has_feature("HTML5")
	$ContinueGameButton.disabled = UserSaveData.current_day <= 0
