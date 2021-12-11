extends InteractiveItem
class_name InteractiveDispencer

export(Resource) var item

func interact_finish(src: Node) -> void:
	var character = src as Character
	assert(character != null, "Only characters should trigger interaction finish")
	character.add_item(item)
