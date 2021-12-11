extends Character
class_name Player

signal inventory_changed(character, inventory)

const PROGRESS_BAR_MULTIPLIER = 10.0


export(bool) var selected = false setget set_selected
export(bool) var interaction_progress_visible = false setget set_interaction_progress_visible
export(NodePath) var camera_node = NodePath()

onready var _selection_indicator: Sprite = $"SelectionIndicator"
onready var _interaction_area: Area2D = $"InteractionArea"
onready var _interaction_progress: TextureProgress = $"Node2D/InteractionProgress"
onready var _camera_transform: RemoteTransform2D = $"CameraTransform"

var _inventory: Array = []

func _ready() -> void:
	_selection_indicator.visible = selected
	_camera_transform.remote_path = "../" + camera_node
	_camera_transform.update_position = selected


func get_interactive() -> Node:
	var objects = _interaction_area.get_overlapping_bodies()
	if objects.size() > 0:
		return objects[0]
	return null


func set_selected(value: bool) -> void:
	selected = value
	if not is_inside_tree():
		return

	_selection_indicator.visible = selected
	_camera_transform.update_position = selected


func set_interaction_progress(current: float, total: float) -> void:
	_interaction_progress.value = current * PROGRESS_BAR_MULTIPLIER
	_interaction_progress.max_value = total * PROGRESS_BAR_MULTIPLIER


func set_interaction_progress_visible(value: bool) -> void:
	_interaction_progress.visible = value


func get_inventory() -> Array:
	return _inventory


func add_item(item: Resource) -> void:
	_inventory.append(item)
	emit_signal("inventory_changed", self, _inventory)


func clear_inventory() -> void:
	_inventory.clear()
	emit_signal("inventory_changed", self, _inventory)
