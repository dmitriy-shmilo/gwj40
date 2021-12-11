extends Node
class_name StateMachine

export(NodePath) var initial_state = NodePath()
onready var _state: State = get_node(initial_state)

var _last_failed_transition: String = ""

func _ready() -> void:
	assert(initial_state != null, "State machine must have an initial state set")
	yield(owner, "ready")
	_state.enter()


func _process(delta: float) -> void:
	_state.process(delta)


func transition(state: String, args: Dictionary = {}) -> bool:
	if not has_node(state):
		if _last_failed_transition != state:
			_last_failed_transition = state
			print("Can't transition to ", state) # TODO: logger with a tag
		return false

	_state.exit()
	_state = get_node(state)
	_state.enter(args)

	return true
