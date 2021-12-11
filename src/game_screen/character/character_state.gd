extends State
class_name CharacterState

const MOVEMENT_ACTIONS = ["down", "up", "left", "right"]

var _character: Character

func _ready() -> void:
	yield(owner, "ready")
	_character = owner as Character
	assert(_character != null, "CharacterState node must be owned by a Character")
