extends CustomerState
class_name CustomerEnteringState

var _current_path_point: int = 0
var _path: PoolVector2Array

func enter(args: Dictionary = {}) -> void:
	assert(_customer.current_seat != null, "When entering, customer must have a seat assigned")
	_path = _customer.current_seat.get_path_points()
	_current_path_point = 0


func process(delta: float) -> void:
	if _current_path_point >= _path.size():
		_customer.direction = _customer.current_seat.direction
		_transition("WaitingState")
		return
		
	var target = _path[_current_path_point]
	var direction = target - _customer.global_position
	
	if direction.length_squared() <= PROXIMITY_THRESHOLD:
		_current_path_point += 1
		return

	direction = direction.normalized()
	_customer.direction = direction
	_customer.current_animation = "run"
	_customer.move_and_slide(direction * _customer.speed)
