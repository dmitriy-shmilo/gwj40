extends Character
class_name Customer

onready var _tween: Tween = $"Tween"
onready var _heart: Sprite = $"Heart"

func _on_InteractiveReceiver_interaction_finished(source) -> void:
	if source.get_inventory().size() == 0:
		return
	_tween.interpolate_property(_heart, "modulate:a", 0, 1.0, 0.25)
	_tween.interpolate_property(_heart, "position", Vector2.ZERO, Vector2(0, -16), 0.25)
	_tween.start()
	yield(_tween, "tween_all_completed")
	_heart.modulate.a = 0
