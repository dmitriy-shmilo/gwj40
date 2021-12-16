extends CustomerState
class_name CustomerConsumingState

var _max_idle_time = 5.0 # TODO: configure
var _current_idle_time = 0.0


func enter(args: Dictionary = {}) -> void:
	_customer.current_animation = "idle"


func process(delta: float) -> void:
	_current_idle_time += delta

	if _current_idle_time >= _max_idle_time:
		# TODO: calculate tips
		_customer.emit_signal("finished", _customer, _customer.current_order)
		_transition("LeavingState")
