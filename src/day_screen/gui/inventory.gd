extends HBoxContainer
class_name InventoryGui

func set_items(items: Array) -> void:
	var pictures = get_children()
	
	for i in range(pictures.size()):
		if i >= items.size():
			pictures[i].visible = false
			pictures[i].texture = null
			continue
		pictures[i].visible = true
		pictures[i].texture = items[i].texture
