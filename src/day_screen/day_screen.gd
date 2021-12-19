extends Node2D
class_name DayScreen

const BASE_ITEM = preload("res://data/item/coffee.tres")
const CUSTOMER = preload("res://day_screen/character/customer/customer.tscn")

export(float) var day_length = 200.0

onready var _gui: Gui = $"Gui"
onready var _camera: Camera2D = $"PlayerCamera"
onready var _floor_tilemap: TileMap = $"FloorWallTileMap"
onready var _fader: Fader = $"Fader"
onready var _space: YSort = $"YSort"
onready var _entry_point = $"YSort/Entry"
onready var _characters = [
	$"YSort/Character1",
	$"YSort/Character2"
]

onready var _seats = [
	$"Seats/Seat1",
	$"Seats/Seat2",
	$"Seats/Seat3",
	$"Seats/Seat4",
	$"Seats/Seat5",
	$"Seats/Seat6",
]

var _current_cash: float = UserSaveData.current_cash
var _selected_character: int = 0
var _dialog_customer: Customer = null
var _current_time = 0.0
var _current_customers = []
var _day_ended = false
var _orders = []

func _ready():
	for i in range(_characters.size()):
		_characters[i].selected = false
		_characters[i].connect("inventory_changed", self, "_on_character_inventory_changed")
		_gui.deselect_character(i)

	_characters[_selected_character].selected = true
	_gui.select_character(_selected_character)
	_create_customer(_seats[randi() % _seats.size()])
	_gui.update_cash(_current_cash)
	
	var rect = _floor_tilemap.get_used_rect()
	rect.position += Vector2.ONE
	rect.size -= Vector2.ONE * 2
	_camera.limit_top = rect.position.y * _floor_tilemap.cell_size.y
	_camera.limit_left = rect.position.x * _floor_tilemap.cell_size.x
	_camera.limit_bottom = (rect.position.y + rect.size.y) * _floor_tilemap.cell_size.y
	_camera.limit_right = (rect.position.x + rect.size.x) * _floor_tilemap.cell_size.x


func _process(delta: float) -> void:
	if _dialog_customer != null and Input.is_action_just_pressed("interact"):
		_dialog_customer = null
		_gui.hide_dialog()

	if Input.is_action_just_pressed("next_char"):
		_characters[_selected_character].selected = false
		_gui.deselect_character(_selected_character)
		_selected_character = (_selected_character + 1) % _characters.size()
		_characters[_selected_character].selected = true
		_gui.select_character(_selected_character)
	
	if _day_ended:
		return
	
	_current_time += delta
	if _current_time >= day_length:
		_current_time = day_length
		if _current_customers.size() == 0:
			_end_day()
	
	_gui.update_time_progress(_current_time, day_length)


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
	customer.connect("finished", self, "_on_customer_finished")
	customer.connect("ordered", self, "_on_customer_ordered")
	customer.connect("left", self, "_on_customer_left")
	customer.connect("unfocused", self, "_on_customer_unfocused")


func _on_customer_finished(customer: Customer, order: Order) -> void:
	_orders.append(order)
	_current_cash += order.payment + order.tips
	_gui.update_cash(_current_cash)


func _on_customer_ordered(customer: Customer, text: String, order: Order) -> void:
	_gui.show_dialog(text, order.ordered_items, customer)
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
	UserSaveData.last_served_orders = _orders
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
	
	if UserSaveData.stocks.get_stock(BASE_ITEM.id) <= 0:
		return

	var index = randi() % _seats.size()
	for i in range(_seats.size()):
		var seat = _seats[(index + i) % _seats.size()]
		if not seat.is_busy:
			_create_customer(seat)
			return
