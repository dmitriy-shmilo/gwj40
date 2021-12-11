extends PlayerState
class_name PlayerMovingState

func process(delta: float) -> void:
	if not _player.selected:
		_transition("IdleState")
		return

	if Input.is_action_just_pressed("interact"):
		var interactive = _player.get_interactive()
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

	_player.direction = direction
	_player.current_animation = "run"
	_player.move_and_slide(direction * _player.speed)
