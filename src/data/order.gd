extends Node
class_name Order

var ordered_items = [] setget set_ordered_items
var served_items = [] setget set_served_items
var ordered_cost = 0.0
var served_cost = 0.0
var payment = 0.0
var tips = 0.0

func set_ordered_items(items: Array) -> void:
	ordered_items = items
	refresh_costs()


func set_served_items(items: Array) -> void:
	served_items = items
	refresh_costs()


func refresh_costs() -> void:
	ordered_cost = 0.0
	for item in ordered_items:
		ordered_cost += item.sell_cost

	served_cost = 0.0
	for item in served_items:
		served_cost += item.sell_cost
