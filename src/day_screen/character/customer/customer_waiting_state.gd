extends CustomerState
class_name CustomerWaitingState

const MAX_ORDER_COUNT = 5
const POSSIBLE_ITEMS = [
	preload("res://data/item/coffee.tres"),
	preload("res://data/item/sugar.tres")
]

var _current_wait_time = 0
var _max_wait_time = 90.0

func enter(args: Dictionary = {}) -> void:
	_customer.current_animation = "idle"
	_customer.show_mood(Customer.Mood.new, false)


func process(delta: float) -> void:
	_current_wait_time += delta
	if _current_wait_time >= _max_wait_time:
		_customer.show_mood(Customer.Mood.unhappy, true)
		_transition("LeavingState")


func interact(player: Player) -> void:
	if _customer.current_order == null:
		var items = _generate_order_items(player.get_inventory().size() > 0)
		if items.size() == 0:
			# impossible order encountered, leave
			_customer.show_mood(Customer.Mood.normal, true)
			_transition("LeavingState")
			return

		var order = Order.new()
		order.ordered_items = items
		_customer.current_order = order
		_customer.emit_signal("ordered", _customer, "msg_order", _customer.current_order)
		_customer.clear_mood()
		return

	if player.get_inventory().size() == 0:
		_customer.emit_signal("ordered", _customer, "msg_order", _customer.current_order)
		return
	
	_customer.current_order.served_items = player.get_inventory().duplicate()
	var score = _customer.current_order.get_score()
	_customer.current_order.payment = _receive_order(_customer.current_order)
	player.clear_inventory()
	
	if score < 0.5:
		# unhappy customer, no tips
		_customer.show_mood(Customer.Mood.unhappy, true)
	elif score > 0.8:
		# happy customer, 10-20% tips
		_customer.show_mood(Customer.Mood.happy, true)
		_customer.current_order.tips = _customer.current_order.payment * (randf() * 0.1 + 0.1)
	else:
		# slightly messed up order, 0-10% tips
		_customer.show_mood(Customer.Mood.normal, true)
		_customer.current_order.tips = _customer.current_order.payment * randf() * 0.1
	_transition("ConsumingState")


func is_interactive() -> bool:
	return true


func _generate_order_items(player_has_stuff: bool) -> Array:
	var order = [
		POSSIBLE_ITEMS[0]
	]

	if not UserSaveData.stocks.reserve(POSSIBLE_ITEMS[0].id, 1):
		return order if player_has_stuff else []

	for i in range(MAX_ORDER_COUNT - 1):
		var item = POSSIBLE_ITEMS[randi() % (POSSIBLE_ITEMS.size() - 1) + 1]
		if randi() % (i + 1) == 0 \
			and UserSaveData.stocks.reserve(item.id, 1):
			order.append(item)

	return order


func _receive_order(order: Order) -> float:
	for item in order.ordered_items:
		UserSaveData.stocks.reserve(item.id, -1)
	return min(order.served_cost, order.ordered_cost)
