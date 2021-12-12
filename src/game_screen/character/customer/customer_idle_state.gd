extends CustomerState
class_name CustomerIdleState

func enter(args: Dictionary = {}) -> void:
	_customer.current_animation = "idle"
	_customer.can_receive = true
