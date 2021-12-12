extends Node2D
class_name Seat

export(NodePath) var seat_path = NodePath()
export(Vector2) var direction = Vector2.RIGHT
export(bool) var is_busy = false

func get_path_points() -> PoolVector2Array:
	return get_node(seat_path).points
