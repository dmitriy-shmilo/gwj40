extends HBoxContainer
class_name StocksRow

signal quantity_changed(row, quantity, diff)

var item: Resource = Item.new()
var starting_quantity: int = 0
var quantity: int = 0 setget set_quantity, get_quantity

onready var _quantity_box: SpinBox = $"QuantityBox"
onready var _item_icon: TextureRect = $"ItemIcon"
onready var _item_name_label: Label = $"ItemNameLabel"
onready var _price_label: Label = $"PriceLabel"


func _ready() -> void:
	_quantity_box.min_value = starting_quantity
	_item_name_label.text = tr(item.name)
	_item_icon.texture = item.texture
	set_quantity(starting_quantity)


func set_quantity(value: int) -> void:
	_quantity_box.value = value


func get_quantity() -> int:
	return int(_quantity_box.value)


func get_quantity_difference() -> int:
	return int(_quantity_box.value) - starting_quantity


func get_price() -> float:
	return (_quantity_box.value - starting_quantity) * item.restock_cost


func _on_QuantityDown_pressed() -> void:
	set_quantity(int(_quantity_box.value) - 1)


func _on_QuantityUp_pressed() -> void:
	set_quantity(int(_quantity_box.value) + 1)


func _on_QuantityBox_value_changed(value: float) -> void:
	var diff = value - starting_quantity
	_price_label.text = "$%0.2f" % (item.restock_cost * diff)
	emit_signal("quantity_changed", self, int(value), int(diff))
