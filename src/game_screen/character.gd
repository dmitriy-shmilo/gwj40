extends KinematicBody2D


export(float) var speed = 100.0
export(bool) var selected = false setget set_selected

onready var _selection_indicator: Sprite = $"SelectionIndicator"
onready var _animation_tree: AnimationTree = $"BodyAnimationTree"
onready var _animation_state: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/playback")

func _ready() -> void:
	_selection_indicator.visible = selected


func _process(delta: float) -> void:
	if not selected:
		return

	var direction: = Vector2.ZERO
	
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	direction = direction.normalized()
	
	if direction != Vector2.ZERO:
		_animation_tree.set("parameters/run/blend_position", direction)
		_animation_tree.set("parameters/idle/blend_position", direction)
		_animation_state.travel("run")
	else:
		_animation_state.travel("idle")
	
	move_and_slide(direction * speed)
	

func set_selected(value: bool) -> void:
	selected = value
	if not is_inside_tree():
		return

	if not selected:
		_animation_state.travel("idle")

	_selection_indicator.visible = selected
