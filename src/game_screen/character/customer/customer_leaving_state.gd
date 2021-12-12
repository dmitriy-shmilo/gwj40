extends CustomerState
class_name CustomerLeavingState

var _current_path_point: int = 0
var _path: PoolVector2Array

func enter(args: Dictionary = {}) -> void:
	_path = _customer.current_seat.get_path_points()
	_current_path_point = _path.size() - 1
	_customer.current_seat.is_busy = false


func process(delta: float) -> void:
	if _current_path_point < 0:
		_customer.queue_free()
		return
		
	var target = _path[_current_path_point]
	var direction = target - _customer.global_position
	
	if direction.length_squared() <= PROXIMITY_THRESHOLD:
		_current_path_point -= 1
		return

	direction = direction.normalized()
	_customer.direction = direction
	_customer.current_animation = "run"
	_customer.move_and_slide(direction * _customer.speed)
