extends CustomerState
class_name CustomerWaitingState

const MAX_ORDER_COUNT = 5
const POSSIBLE_ITEMS = [
	preload("res://data/item/coffee.tres"),
	preload("res://data/item/sugar.tres")
]

var _current_wait_time = 0
var _max_wait_time = 30.0 # TODO: configure or randomize

func enter(args: Dictionary = {}) -> void:
	_customer.current_animation = "idle"


func process(delta: float) -> void:
	_current_wait_time += delta


func interact(player: Player) -> void:
	if _customer.current_order == null:
		var items = _generate_order_items()
		if items.size() == 0:
			# impossible order encountered, leave
			_transition("LeavingState")
			return

		var order = Order.new()
		order.ordered_items = items
		_customer.current_order = order
		_customer.emit_signal("ordered", _customer, "msg_order", _customer.current_order)
		return

	if player.get_inventory().size() == 0:
		_customer.emit_signal("ordered", _customer, "msg_order", _customer.current_order)
		return
	
	_customer.current_order.served_items = player.get_inventory().duplicate()
	_customer.current_order.payment = _receive_order(_customer.current_order)
	# TODO: calculate tips
	player.clear_inventory()
	_customer.show_mood()
	_transition("ConsumingState")


func is_interactive() -> bool:
	return true


func _generate_order_items() -> Array:
	if not UserSaveData.stocks.reserve(POSSIBLE_ITEMS[0].id, 1):
		return []

	var order = [
		POSSIBLE_ITEMS[0]
	]

	for i in range(MAX_ORDER_COUNT - 1):
		var item = POSSIBLE_ITEMS[randi() % (POSSIBLE_ITEMS.size() - 1) + 1]
		if randi() % (i + 1) == 0 \
			and UserSaveData.stocks.reserve(item.id, 1):
			order.append(item)

	return order


func _receive_order(order: Order) -> float:
	# TODO: calculate order correctness
	for item in order.ordered_items:
		UserSaveData.stocks.reserve(item.id, -1)
	return order.served_cost
