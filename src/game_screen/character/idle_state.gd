extends CharacterState
class_name IdleState

func enter(_args = {}) -> void:
	_character.current_animation = "idle"


func process(_delta) -> void:
	if not _character.selected:
		return
	
	if Input.is_action_just_pressed("interact"):
		var interactive = _character.get_interactive()
		if interactive != null:
			_transition("InteractingState", { "target" : interactive })
			return

	for a in MOVEMENT_ACTIONS:
		if Input.is_action_just_pressed(a):
			_transition("MovingState")
			return
