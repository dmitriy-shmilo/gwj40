extends Node2D
class_name Character

export(float) var speed = 100.0
export(Vector2) var direction = Vector2.ZERO setget set_direction
export(String) var current_animation = "idle" setget set_current_animation

# TODO: inject these, don't assume the tree structure
onready var _animation_tree: AnimationTree = $"BodyAnimationTree"
onready var _animation_state: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/playback")
onready var _character_state: StateMachine = $"CharacterState"

func set_direction(dir: Vector2) -> void:
	direction = dir
	_animation_tree.set("parameters/run/blend_position", direction)
	_animation_tree.set("parameters/idle/blend_position", direction)


func set_current_animation(name: String) -> void:
	current_animation = name
	_animation_state.travel(name)
