extends StaticBody2D
class_name InteractiveItem

signal interaction_started(source)
signal interaction_finished(source)
signal interaction_stopped(source)

export(float) var interaction_time = 5.0

func can_interact(source: Node) -> bool:
	return true


func interact_start(source: Node) -> void:
	emit_signal("interaction_started", source)


func interact_finish(source: Node) -> void:
	emit_signal("interaction_finished", source)


func interact_stop(source: Node) -> void:
	emit_signal("interaction_stopped", source)
