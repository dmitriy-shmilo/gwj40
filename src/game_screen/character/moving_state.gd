extends CharacterState
class_name MovingState

func process(delta: float) -> void:
	if not _character.selected:
		_transition("IdleState")
		return

	if Input.is_action_just_pressed("interact"):
		var interactive = _character.get_interactive()
		if interactive != null:
			_transition("InteractingState", { "target" : interactive })
			return

	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	direction = direction.normalized()
	if direction == Vector2.ZERO:
		_transition("IdleState")
		return

	_character.direction = direction
	_character.current_animation = "run"
	_character.move_and_slide(direction * _character.speed)
