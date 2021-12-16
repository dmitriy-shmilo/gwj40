extends Node2D
class_name DayScreen

const CUSTOMER = preload("res://day_screen/character/customer/customer.tscn")

export(float) var day_length = 20.0

onready var _gui: Gui = $"Gui"
onready var _fader: Fader = $"Fader"
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

var _current_cash: float = UserSaveData.current_cash
var _selected_character: int = 0
var _dialog_customer: Customer = null
var _current_time = 0.0
var _current_customers = []
var _day_ended = false

func _ready():
	for c in _characters:
		c.selected = false
		c.connect("inventory_changed", self, "_on_character_inventory_changed")
	_characters[_selected_character].selected = true
	_create_customer(_seats[0])
	_gui.update_cash(_current_cash)


func _process(delta: float) -> void:
	if _dialog_customer != null and Input.is_action_just_pressed("interact"):
		_dialog_customer = null
		_gui.hide_dialog()

	if Input.is_action_just_pressed("next_char"):
		_characters[_selected_character].selected = false
		_selected_character = (_selected_character + 1) % _characters.size()
		_characters[_selected_character].selected = true
	
	if _day_ended:
		return
	
	_current_time += delta	
	if _current_time >= day_length:
		_current_time = day_length
		if _current_customers.size() == 0:
			_end_day()


func _unhandled_input(event):
	if event.is_action("system_pause"):
		get_tree().paused = true
		_gui.pause()


func _create_customer(seat: Seat) -> void:
	var customer = CUSTOMER.instance()
	customer.global_position = _entry_point.global_position
	_space.add_child(customer)
	_current_customers.append(customer)
	customer.enter(seat)
	customer.connect("paid", self, "_on_customer_paid")
	customer.connect("ordered", self, "_on_customer_ordered")
	customer.connect("left", self, "_on_customer_left")
	customer.connect("unfocused", self, "_on_customer_unfocused")


func _on_customer_paid(customer: Customer, amount: float, tips: float) -> void:
	_current_cash += amount + tips
	_gui.update_cash(_current_cash)


func _on_customer_ordered(customer: Customer, text: String, order: Array) -> void:
	_gui.show_dialog(text, order)
	_dialog_customer = customer


func _on_customer_unfocused(customer: Customer, player: Player) -> void:
	if _dialog_customer == customer:
		_gui.hide_dialog()
		_dialog_customer = null


func _on_customer_left(customer: Customer) -> void:
	_current_customers.erase(customer)
	customer.queue_free()


func _end_day() -> void:
	_day_ended = true
	_fader.fade_out()
	yield(_fader, "fade_out_completed")
	UserSaveData.current_cash = _current_cash
	get_tree().change_scene("res://night_screen/night_screen.tscn")


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
	# TODO: should probably just stop the timer
	if _current_time >= day_length:
		return

	var index = randi() % _seats.size()
	if _seats[index].is_busy:
		return
	
	_create_customer(_seats[index])

