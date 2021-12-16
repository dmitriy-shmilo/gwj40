extends HBoxContainer
class_name InventoryGui

func set_items(items: Array) -> void:
	var pictures = get_children()
	
	for i in range(pictures.size()):
		if i >= items.size():
			pictures[i].visible = false
			pictures[i].texture.region.position.x = 0
			continue
		pictures[i].visible = true
		# TODO: replace this with an AtlasTexture resource on an item
		pictures[i].texture.region.position.x = items[i].sprite_frame * 8
