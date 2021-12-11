extends CharacterState
class_name InteractingState


func enter(args = {}) -> void:
	if not args.has("target"):
		print("Can't enter interacting state without target")
		_transition("IdleState")
		return
	
	var target = args["target"]
	_character.direction = (target.global_position - _character.global_position).normalized()
	_character.current_animation = "idle"

func process(delta: float) -> void:
	for a in MOVEMENT_ACTIONS:
		if Input.is_action_just_pressed(a):
			_transition("MovingState")
			return
	# TODO: interact

