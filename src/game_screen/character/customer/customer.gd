extends Character
class_name Customer

export(bool) var can_receive = true setget set_can_receive

var current_seat: Seat = null

onready var _tween: Tween = $"Tween"
onready var _heart: Sprite = $"Heart"
onready var _receiver: InteractiveReceiver = $"Receiver"


func set_can_receive(value: bool) -> void:
	_receiver.is_active = value


func enter(seat: Seat) -> void:
	current_seat = seat
	current_seat.is_busy = true
	_character_state.transition("EnteringState")


func leave() -> void:
	current_seat.is_busy = false
	_character_state.transition("LeavingState")


func _on_InteractiveReceiver_interaction_finished(source) -> void:
	if source.get_inventory().size() == 0:
		return
	_tween.interpolate_property(_heart, "modulate:a", 0, 1.0, 0.25)
	_tween.interpolate_property(_heart, "position", Vector2.ZERO, Vector2(0, -16), 0.25)
	_tween.start()
	yield(_tween, "tween_all_completed")
	_heart.modulate.a = 0
	leave()
