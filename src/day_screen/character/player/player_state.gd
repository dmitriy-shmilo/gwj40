extends CharacterState
class_name PlayerState

const MOVEMENT_ACTIONS = ["down", "up", "left", "right"]

var _player: Player = null

func _ready() -> void:
	yield(owner, "ready")
	_player = owner as Player
	assert(_player != null, "PlayerState node must be owned by a Player")
