extends CustomerState
class_name CustomerMovingState

const PROXIMITY_THRESHOLD = 4.0

var _path: PoolVector2Array
var _current_point: int = 0

func enter(args: Dictionary = {}) -> void:
	_path = args.get("path") as PoolVector2Array
	if _path == null:
		printerr("Customer can't move without a path")
		_transition("IdleState")
		return
	_customer.can_receive = false


func process(delta: float) -> void:
	if _current_point >= _path.size():
		print(_customer, " completed its path")
		_transition("IdleState")
		return
		
	var target = _path[_current_point]
	var direction = target - _customer.global_position
	
	if direction.length_squared() <= PROXIMITY_THRESHOLD:
		_current_point += 1
		return

	direction = direction.normalized()
	_customer.direction = direction
	_customer.current_animation = "run"
	_customer.move_and_slide(direction * _customer.speed)
