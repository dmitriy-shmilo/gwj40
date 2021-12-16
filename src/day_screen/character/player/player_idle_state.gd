extends PlayerState
class_name PlayerIdleState

func enter(_args = {}) -> void:
	_player.current_animation = "idle"


func process(_delta) -> void:
	if not _player.selected:
		return
	
	if Input.is_action_just_pressed("interact"):
		var interactive = _player.get_interactive()
		if interactive != null:
			_transition("InteractingState", { "target" : interactive })
			return

	for a in MOVEMENT_ACTIONS:
		if Input.is_action_just_pressed(a):
			_transition("MovingState")
			return
