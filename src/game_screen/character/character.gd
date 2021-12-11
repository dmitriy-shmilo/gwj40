extends KinematicBody2D
class_name Character

const PROGRESS_BAR_MULTIPLIER = 10.0

export(float) var speed = 100.0
export(bool) var selected = false setget set_selected
export(Vector2) var direction = Vector2.ZERO setget set_direction
export(String) var current_animation = "idle" setget set_current_animation
export(bool) var interaction_progress_visible = false setget set_interaction_progress_visible

onready var _selection_indicator: Sprite = $"SelectionIndicator"
onready var _animation_tree: AnimationTree = $"BodyAnimationTree"
onready var _animation_state: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/playback")
onready var _interaction_area: Area2D = $"InteractionArea"
onready var _interaction_progress: TextureProgress = $"Node2D/InteractionProgress"

var _inventory: Array = []

func _ready() -> void:
	_selection_indicator.visible = selected
	_animation_state.travel(current_animation)


func get_interactive() -> Node:
	var objects = _interaction_area.get_overlapping_bodies()
	if objects.size() > 0:
		return objects[0]
	return null


func set_selected(value: bool) -> void:
	selected = value
	if not is_inside_tree():
		return

	if not selected:
		_animation_state.travel("idle")

	_selection_indicator.visible = selected


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


func add_item(item_id: int) -> void:
	_inventory.append(item_id)


func clear_inventory() -> void:
	_inventory.clear()
