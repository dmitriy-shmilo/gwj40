extends CustomerState
class_name CustomerWaitingState

const possible_items = [
	preload("res://data/item/coffee.tres"),
	preload("res://data/item/sugar.tres"),
	preload("res://data/item/milk.tres")
]

var _current_wait_time = 0
var _max_wait_time = 30.0 # TODO: configure or randomize

func enter(args: Dictionary = {}) -> void:
	_customer.current_animation = "idle"


func process(delta: float) -> void:
	_current_wait_time += delta


func interact(player: Player) -> void:
	if _customer.current_order.size() == 0:
		_customer.current_order = _generate_order()
		_customer.emit_signal("ordered", _customer, "msg_order", _customer.current_order)
		return

	if player.get_inventory().size() == 0:
		_customer.emit_signal("ordered", _customer, "msg_order", _customer.current_order)
		return

	var payment = _receive_order(player.get_inventory())
	player.clear_inventory()
	_customer.show_mood()
	_transition("ConsumingState", { "payment" : payment })


func is_interactive() -> bool:
	return true


func _generate_order() -> Array:
	var order = [
		possible_items[0]
	]

	if randi() % 2 == 0:
		order.append(possible_items[1])
		if randi() % 5 == 0:
			order.append(possible_items[1])

	return order


func _receive_order(items: Array) -> float:
	# TODO: calculate order correctness
	return 10.0
