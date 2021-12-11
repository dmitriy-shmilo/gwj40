extends KinematicBody2D
class_name Character

signal inventory_changed(character, inventory)

const PROGRESS_BAR_MULTIPLIER = 10.0

export(float) var speed = 100.0
export(bool) var selected = false setget set_selected
export(Vector2) var direction = Vector2.ZERO setget set_direction
export(String) var current_animation = "idle" setget set_current_animation
export(bool) var interaction_progress_visible = false setget set_interaction_progress_visible
export(NodePath) var camera_node = NodePath()

onready var _selection_indicator: Sprite = $"SelectionIndicator"
onready var _animation_tree: AnimationTree = $"BodyAnimationTree"
onready var _animation_state: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/playback")
onready var _interaction_area: Area2D = $"InteractionArea"
onready var _interaction_progress: TextureProgress = $"Node2D/InteractionProgress"
onready var _camera_transform: RemoteTransform2D = $"CameraTransform"
onready var _character_state: StateMachine = $"CharacterState"

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


func set_direction(dir: Vector2) -> void:
	direction = dir
	_animation_tree.set("parameters/run/blend_position", direction)
	_animation_tree.set("parameters/idle/blend_position", direction)


func set_current_animation(name: String) -> void:
	current_animation = name
	_animation_state.travel(name)


func set_interaction_progress(current: float, total: float) -> void:
	_interaction_progress.value = current * PROGRESS_BAR_MULTIPLIER
	_interaction_progress.max_value = total * PROGRESS_BAR_MULTIPLIER


func set_interaction_progress_visible(value: bool) -> void:
	_interaction_progress.visible = value


func get_inventory() -> Array:
	return _inventory


func add_item(item_id: int) -> void:
	_inventory.append(item_id)
	emit_signal("inventory_changed", self, _inventory)


func clear_inventory() -> void:
	_inventory.clear()
	emit_signal("inventory_changed", self, _inventory)
