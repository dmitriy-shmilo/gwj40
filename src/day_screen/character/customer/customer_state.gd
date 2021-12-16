extends CharacterState
class_name CustomerState

const PROXIMITY_THRESHOLD = 4.0

var _customer: Customer = null

func _ready() -> void:
	yield(owner, "ready")
	_customer = owner as Customer
	assert(_customer != null, "CustomerState node must be owned by a Customer")


func is_interactive() -> bool:
	return false


func interaction_time() -> float:
	return 1.0


func interact(player: Player) -> void:
	pass
