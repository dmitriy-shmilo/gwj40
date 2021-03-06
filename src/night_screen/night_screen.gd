extends Control

const ORDER_ROW_SCENE = preload("res://night_screen/gui/order_row.tscn")
const STOCK_ROW_SCENE = preload("res://night_screen/gui/stocks_row.tscn")
const REQUIRED_ITEM = preload("res://data/item/coffee.tres")

onready var _fader = $"Fader"
onready var _title_label = $"TitleLabel"

onready var _order_list = $"OrderListContainer/OrderList"
onready var _order_list_header = $"OrderListContainer/OrderList/OrderListHeader"
onready var _order_list_footer = $"OrderListContainer/OrderList/OrderListFooter"

onready var _stocks_list = $"StocksListContainer/StocksList"
onready var _stocks_list_header = $"StocksListContainer/StocksList/StocksListHeader"
onready var _stocks_list_footer = $"StocksListContainer/StocksList/StocksListFooter"

onready var _missing_items_label: Label = $"StocksListContainer/StocksList/MissingItemsLabel"
onready var _in_debt_label: Label = $"StocksListContainer/StocksList/InDebtLabel"
onready var _projected_cash_label: Label = $"CashLabel"

onready var _next_day_button: Button = $"NextDayButton"
onready var _next_screen_button: Button = $"NextScreenButton"
onready var _prev_screen_button: Button = $"PreviousScreenButton"

onready var _screens = [
	$"OrderListContainer",
	$"StocksListContainer"
]

var _current_screen = 0
var _restock_cost = 0.0
var _projected_cash = 0.0
var _required_items_missing = false

func _ready() -> void:
	_title_label.text = tr("ui_night_title") % UserSaveData.current_day
	_setup_order_list()
	_setup_stocks_list()
	
	for screen in _screens:
		screen.visible = false
	
	_screens[_current_screen].visible = true
	_projected_cash = UserSaveData.current_cash
	
	_refresh_buttons()
	_refresh_labels()


func _refresh_buttons() -> void:
	_prev_screen_button.disabled = _current_screen <= 0
	_next_screen_button.disabled = _current_screen >= _screens.size() - 1
	_next_day_button.disabled = _required_items_missing or _projected_cash < 0


func _refresh_labels() -> void:
	_missing_items_label.visible = _required_items_missing
	_in_debt_label.visible = _projected_cash < 0
	_projected_cash_label.text = "$%0.2f" % _projected_cash


func _setup_order_list() -> void:
	var total_payment = 0.0
	var total_tips = 0.0
	UserSaveData.last_served_orders.invert()
	for order in UserSaveData.last_served_orders:
		var order_row = ORDER_ROW_SCENE.instance()
		order_row.order = order
		_order_list.add_child_below_node(_order_list_header, order_row)
		total_payment += order.payment
		total_tips += order.tips
	
	_order_list_header.text = tr("ui_order_list_header") % [UserSaveData.last_served_orders.size()]
	_order_list_footer.text = tr("ui_order_list_footer") % [total_payment, total_tips]


func _setup_stocks_list() -> void:
	_stocks_list_footer.text = tr("ui_stocks_list_footer") % 0.0
	var stocks = UserSaveData.stocks
	var items = stocks.items.duplicate()
	items.invert()
	for item in items:
		# TODO: check for unlocks
		var row = STOCK_ROW_SCENE.instance()
		row.item = item
		row.starting_quantity = stocks.get_stock(item.id)
		row.connect("quantity_changed", self, "_on_stocks_row_quantity_changed")
		_stocks_list.add_child_below_node(_stocks_list_header, row)
		if item == REQUIRED_ITEM:
			_required_items_missing = row.starting_quantity <= 0
			_refresh_buttons()
			_refresh_labels()


func _on_stocks_row_quantity_changed(row: StocksRow, quantity: int, diff: int) -> void:
	_restock_cost = 0.0
	for row in _stocks_list.get_children():
		if not row is StocksRow:
			continue
		_restock_cost += row.get_price()
		if row.item == REQUIRED_ITEM:
			_required_items_missing = row.quantity <= 0
			_refresh_buttons()
			_refresh_labels()
	
	_stocks_list_footer.text = tr("ui_stocks_list_footer") % _restock_cost
	_projected_cash = UserSaveData.current_cash - _restock_cost

	_refresh_buttons()
	_refresh_labels()


func _on_NextDayButton_pressed() -> void:
	if UserSaveData.current_cash < _restock_cost:
		return

	_fader.fade_out()
	yield(_fader, "fade_out_completed")

	for row in _stocks_list.get_children():
		if not row is StocksRow:
			continue
		UserSaveData.stocks.set_stock(row.item.id, row.quantity)

	UserSaveData.current_cash -= _restock_cost
	UserSaveData.current_day += 1
	UserSaveData.save_data()
	get_tree().change_scene("res://day_screen/day_screen.tscn")


func _on_PreviousScreenButton_pressed() -> void:
	if _current_screen <= 0:
		return
	
	_screens[_current_screen].visible = false
	_current_screen -= 1
	_screens[_current_screen].visible = true
	
	_refresh_buttons()


func _on_NextScreenButton_pressed() -> void:
	if _current_screen >= _screens.size() - 1:
		return
	
	_screens[_current_screen].visible = false
	_current_screen += 1
	_screens[_current_screen].visible = true
	
	_refresh_buttons()
