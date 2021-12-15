extends Reference
class_name Stocks

var items = [
	preload("res://data/item/coffee.tres"),
	preload("res://data/item/milk.tres"),
	preload("res://data/item/sugar.tres")
]

var _data = {}

func _init() -> void:
	for item in items:
		_data[item.id] = 0.0


func get_stock(id: int) -> float:
	if _data.has(id):
		return _data[id]
	_data[id] = 0.0
	return 0.0


func set_stock(id: int, value: float) -> void:
	_data[id] = value


func increment_stock(id: int, value: float) -> float:
	if _data.has(id):
		var val = _data[id] + value
		_data[id] = val
		return val

	_data[id] = value
	return value
