extends InteractiveItem
class_name InteractiveDispencer

export(int) var item_id  = -1

func interact_finish(src: Node) -> void:
	var character = src as Character
	assert(character != null, "Only characters should trigger interaction finish")
	character.add_item(item_id)
