extends Node
class_name Gui

onready var _inventories: = [
	$"Hud/Character1/Inventory"
]

func update_inventory(index: int, inventory: Array) -> void:
	_inventories[index].text = str(inventory)
