extends Node
class_name State

var _state_machine = null


func _ready() -> void:
	_state_machine = get_parent()


func process(_delta) -> void:
	pass


func enter(_args: = {}) -> void:
	pass


func exit() -> void:
	pass


func _transition(state: String, args: Dictionary = {}) -> bool:
	return _state_machine.transition(state, args)
