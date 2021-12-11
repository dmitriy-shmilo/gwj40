extends CharacterState
class_name InteractingState


var _current_progress = 0
var _total_progress = 0

func enter(args = {}) -> void:
	var target = args.get("target") as InteractiveItem
	
	if target == null:
		print("Can't enter InteractingState without an InteractiveItem target")
		_transition("IdleState")
		return
	
	_character.interaction_progress_visible = true
	_current_progress = 0
	_total_progress = target.interaction_time
	_character.direction = (target.global_position - _character.global_position).normalized()
	_character.current_animation = "idle"


func exit() -> void:
	_character.interaction_progress_visible = false


func process(delta: float) -> void:
	_current_progress += delta
	_character.set_interaction_progress(_current_progress, _total_progress)

	if _current_progress >= _total_progress:
		print("Interaction done!")
		_transition("IdleState")
	
	if not _character.selected:
		return

	# cancel interaction
	# TODO: consider an option to cancel interaction on move
	if Input.is_action_just_pressed("interact"):
		_transition("IdleState")
		return
