extends CustomerState
class_name CustomerConsumingState

var _max_idle_time = 5.0 # TODO: configure
var _current_idle_time = 0.0
var _payment = 0.0


func enter(args: Dictionary = {}) -> void:
	_customer.current_animation = "idle"
	_payment = args.get("payment")


func process(delta: float) -> void:
	_current_idle_time += delta

	if _current_idle_time >= _max_idle_time:
		# TODO: calculate tips
		_customer.emit_signal("paid", _payment, 0.0)
		_transition("LeavingState")
