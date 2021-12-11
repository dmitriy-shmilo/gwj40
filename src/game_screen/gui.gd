extends Node
class_name Gui

onready var _inventories: = [
	$"Hud/Character1/Inventory",
	$"Hud/Character2/Inventory"
]

func update_inventory(index: int, inventory: Array) -> void:
	var container: HBoxContainer = _inventories[index]
	var pictures = container.get_children()
	
	for i in range(pictures.size()):
		if i >= inventory.size():
			pictures[i].visible = false
			pictures[i].texture.region.position.x = 0
			continue
		pictures[i].visible = true
		pictures[i].texture.region.position.x = inventory[i].sprite_frame * 8
