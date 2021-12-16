extends HBoxContainer
class_name OrderRow

var order: Order = null setget set_order

onready var _inventory: InventoryGui = $"Inventory"
onready var _wrong_order_label: Label = $"WrongOrderLabel"
onready var _price_label: Label = $"PriceLabel"

func _ready() -> void:
	_refresh()


func set_order(value: Order) -> void:
	order = value
	if is_inside_tree():
		_refresh()


func _refresh() -> void:
	if order == null:
		_wrong_order_label.visible = false
		_price_label.visible = false
		_inventory.visible = false
		return

	_inventory.visible = true
	_inventory.set_items(order.served_items)
	_wrong_order_label.visible = order.get_score() < 1.0
	_price_label.visible = true
	_price_label.text = "$%0.2f + $%0.2f" % [order.payment, order.tips]
