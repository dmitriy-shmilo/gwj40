extends Node2D
class_name GameScreen

const CUSTOMER = preload("res://game_screen/character/customer/customer.tscn")

onready var _gui: Gui = $"Gui"
onready var _space: YSort = $"YSort"
onready var _entry_point = $"YSort/Entry"
onready var _characters = [
	$"YSort/Character1",
	$"YSort/Character2"
]
onready var _seat_paths = [
	$"SeatPath1",
	$"SeatPath2",
	$"SeatPath3",
	$"SeatPath4",
]

onready var _seats = [
	$"YSort/Seat1",
	$"YSort/Seat2",
	$"YSort/Seat3",
	$"YSort/Seat4"
]

var _current_cash: float = 0.0
var _selected_character: int = 0

func _ready():
	for c in _characters:
		c.selected = false
		c.connect("inventory_changed", self, "_on_character_inventory_changed")
	_characters[_selected_character].selected = true
	create_customer(_seats[0])
	


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("next_char"):
		_characters[_selected_character].selected = false
		_selected_character = (_selected_character + 1) % _characters.size()
		_characters[_selected_character].selected = true


func _unhandled_input(event):
	if event.is_action("system_pause"):
		get_tree().paused = true
		_gui.pause()


func create_customer(seat: Seat) -> void:
	var customer = CUSTOMER.instance()
	customer.global_position = _entry_point.global_position
	_space.add_child(customer)
	customer.enter(seat)


func _on_character_inventory_changed(sender: Player, inventory: Array) -> void:
	var index = _characters.find(sender)
	assert(index > -1)
	_gui.update_inventory(index, inventory)


func _on_QuitButton_pressed():
	_gui.unpause()
	get_tree().paused = false
	var err = get_tree().change_scene("res://title_screen/title_screen.tscn")
	ErrorHandler.handle(err)


func _on_ContinueButton_pressed():
	_gui.unpause()
	get_tree().paused = false


func _on_CustomerSpawnTimer_timeout() -> void:
	var index = randi() % _seats.size()
	if _seats[index].is_busy:
		return
	
	create_customer(_seats[index])
