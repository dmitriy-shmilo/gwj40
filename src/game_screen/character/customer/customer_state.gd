extends CharacterState
class_name CustomerState

var _customer: Customer = null

func _ready() -> void:
	yield(owner, "ready")
	_customer = owner as Customer
	assert(_customer != null, "CustomerState node must be owned by a Customer")
