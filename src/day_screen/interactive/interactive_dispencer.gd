extends InteractiveItem
class_name InteractiveDispencer

export(Resource) var item
export (NodePath) var sprite_path


var _sprite: Sprite

func _ready() -> void:
	_sprite = get_node(sprite_path)


func can_interact(src: Node) -> bool:
	var character = src as Character
	assert(character != null, "Only characters should trigger interaction")
	if not is_active:
		return false

	# TODO: indicate out of stock
	if UserSaveData.stocks.get_stock(item.id) <= 0:
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
	UserSaveData.stocks.modify_stock(item.id, -1)


func target(source: Node) -> void:
	.target(source)
	_sprite.material.set_shader_param("show_line", 1.0)


func untarget(source: Node) -> void:
	.untarget(source)
	_sprite.material.set_shader_param("show_line", 0.0)
