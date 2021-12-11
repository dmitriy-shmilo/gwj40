extends InteractiveItem
class_name InteractiveReceiver

func interact_finish(src: Node) -> void:
	var character = src as Character
	assert(character != null, "Only characters should trigger interaction finish")
	character.clear_inventory()
