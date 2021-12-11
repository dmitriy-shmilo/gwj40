extends Node2D
class_name GameScreen

onready var _gui: Gui = $"Gui"
onready var _pause_container: ColorRect = $Gui/PauseContainer
onready var _characters = [
	$"YSort/Character1",
	$"YSort/Character2"
]

var _selected_character: int = 0

func _ready():
	for c in _characters:
		c.selected = false
		c.connect("inventory_changed", self, "_on_character_inventory_changed")
	_characters[_selected_character].selected = true


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("next_char"):
		_characters[_selected_character].selected = false
		_selected_character = (_selected_character + 1) % _characters.size()
		_characters[_selected_character].selected = true


func _unhandled_input(event):
	if event.is_action("system_pause"):
		get_tree().paused = true
		_pause_container.visible = true


func _on_character_inventory_changed(sender: Character, inventory: Array) -> void:
	var index = _characters.find(sender)
	assert(index > -1)
	_gui.update_inventory(index, inventory)


func _on_QuitButton_pressed():
	_pause_container.visible = false
	get_tree().paused = false
	var err = get_tree().change_scene("res://title_screen/title_screen.tscn")
	ErrorHandler.handle(err)


func _on_ContinueButton_pressed():
	_pause_container.visible = false
	get_tree().paused = false
