extends Control

const ORDER_ROW_SCENE = preload("res://night_screen/gui/order_row.tscn")

onready var _fader = $"Fader"
onready var _title_label = $"TitleLabel"
onready var _order_list = $"ScrollContainer/OrderList"
onready var _order_list_header = $"ScrollContainer/OrderList/OrderListHeader"
onready var _order_list_footer = $"ScrollContainer/OrderList/OrderListFooter"

func _ready() -> void:
	_title_label.text = tr("ui_night_title") % UserSaveData.current_day
	
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


func _on_NextDayButton_pressed() -> void:
	_fader.fade_out()
	yield(_fader, "fade_out_completed")
	UserSaveData.current_day += 1
	UserSaveData.save_data()
	get_tree().change_scene("res://day_screen/day_screen.tscn")
