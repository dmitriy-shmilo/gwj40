extends InteractiveItem
class_name InteractiveDispencer

export(Resource) var item

func can_interact(src: Node) -> bool:
	var character = src as Character
	assert(character != null, "Only characters should trigger interaction")
	if not is_active:
		return false

	if not item.unique:
		return true
	
	for i in character.get_inventory():
		if i.id == item.id:
			return false
	
	return true


func interact_finish(src: Node) -> void:
	var character = src as Character
	assert(character != null, "Only characters should trigger interaction finish")
	character.add_item(item)
