extends KinematicBody2D
class_name Character

export(float) var speed = 100.0
export(bool) var selected = false setget set_selected
export(Vector2) var direction = Vector2.ZERO setget set_direction
export(String) var current_animation = "idle" setget set_current_animation

onready var _selection_indicator: Sprite = $"SelectionIndicator"
onready var _animation_tree: AnimationTree = $"BodyAnimationTree"
onready var _animation_state: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/playback")
onready var _interaction_area: Area2D = $"InteractionArea"

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
