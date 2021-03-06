extends StaticBody2D
class_name InteractiveItem

signal interaction_started(source)
signal interaction_finished(source)
signal interaction_stopped(source)
signal targeted(source)
signal untargeted(source)

export(bool) var is_active = true
export(float) var interaction_time = 5.0

func can_interact(source: Node) -> bool:
	return is_active


func interact_start(source: Node) -> void:
	emit_signal("interaction_started", source)


func interact_finish(source: Node) -> void:
	emit_signal("interaction_finished", source)


func interact_stop(source: Node) -> void:
	emit_signal("interaction_stopped", source)


func target(source: Node) -> void:
	emit_signal("targeted", source)


func untarget(source: Node) -> void:
	emit_signal("untargeted", source)
