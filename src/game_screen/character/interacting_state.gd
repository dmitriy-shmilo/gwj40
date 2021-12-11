extends CharacterState
class_name InteractingState


var _current_progress = 0
var _total_progress = 0
var _target: InteractiveItem = null

func enter(args = {}) -> void:
	_target = args.get("target") as InteractiveItem
	
	if _target == null:
		print("Can't enter InteractingState without an InteractiveItem target")
		_transition("IdleState")
		return
	
	_character.interaction_progress_visible = true
	_current_progress = 0

	_character.direction = (_target.global_position - _character.global_position).normalized()
	if _target.can_interact(_character):
		_target.interact_start(_character)
		_total_progress = _target.interaction_time
		_character.current_animation = "idle"
	else:
		_transition("IdleState")


func exit() -> void:
	_character.interaction_progress_visible = false


func process(delta: float) -> void:
	_current_progress += delta
	_character.set_interaction_progress(_current_progress, _total_progress)

	if _current_progress >= _total_progress:
		_target.interact_finish(_character)
		_transition("IdleState")
	
	if not _character.selected:
		return

	# cancel interaction
	# TODO: consider an option to cancel interaction on move
	if Input.is_action_just_pressed("interact"):
		_transition("IdleState")
		_target.interact_stop(_character)
		return
