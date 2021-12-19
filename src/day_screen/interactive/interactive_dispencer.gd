extends InteractiveItem
class_name InteractiveDispencer

const BASE_ITEM = preload("res://data/item/coffee.tres")

signal base_already_present(source)
signal missing_base(source)
signal out_of_stock(source)

export(Resource) var item
export(NodePath) var sprite_path

var _sprite: Sprite

func _ready() -> void:
	_sprite = get_node(sprite_path)


func can_interact(src: Node) -> bool:
	var character = src as Character
	assert(character != null, "Only characters should trigger interaction")
	if not is_active:
		return false

	if UserSaveData.stocks.get_stock(item.id) <= 0:
		emit_signal("out_of_stock", self)
		return false

	var base_present = false
	
	for i in character.get_inventory():
		if i.id == BASE_ITEM.id:
			base_present = true

	if item.id == BASE_ITEM.id and base_present:
		emit_signal("base_already_present", self)
		return false
	
	if item.id != BASE_ITEM.id and not base_present:
		emit_signal("missing_base", self)
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
