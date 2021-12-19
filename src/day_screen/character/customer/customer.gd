extends Character
class_name Customer

const BODY_TEXTURES = [
	preload("res://assets/art/customer1.png"),
	preload("res://assets/art/customer2.png"),
	preload("res://assets/art/customer3.png"),
	preload("res://assets/art/customer4.png")
]

signal finished(customer, order)
signal ordered(customer, text, order)
signal left(customer)
signal unfocused(customer, player)

var texture_index: int = 0
var current_seat: Seat = null
var current_order: Order = null

onready var _tween: Tween = $"Tween"
onready var _heart: Sprite = $"Heart"
onready var _receiver: InteractiveReceiver = $"Receiver"
onready var _body_sprite: Sprite = $"BodySprite"

func enter(seat: Seat) -> void:
	current_seat = seat
	current_seat.is_busy = true
	_character_state.transition("EnteringState")
	texture_index = randi() % BODY_TEXTURES.size()
	_body_sprite.texture = BODY_TEXTURES[texture_index]


# TODO: pass different moods here
func show_mood() -> void:
	_tween.interpolate_property(_heart, "modulate:a", 0, 1.0, 0.25)
	_tween.interpolate_property(_heart, "position", Vector2.ZERO, Vector2(0, -16), 0.25)
	_tween.start()
	yield(_tween, "tween_all_completed")
	_heart.modulate.a = 0


func _on_InteractiveReceiver_interaction_finished(source) -> void:
	var player = source as Player
	assert(player != null, "Only players can interact with customers")
	_character_state._state.interact(player)


func _on_CharacterState_state_changed(old_state, new_state) -> void:
	_receiver.is_active = new_state.is_interactive()
	_receiver.interaction_time = new_state.interaction_time()


func _on_Receiver_targeted(source) -> void:
	_body_sprite.material.set_shader_param("show_line", 1.0)


func _on_Receiver_untargeted(source) -> void:
	_body_sprite.material.set_shader_param("show_line", 0.0)
	emit_signal("unfocused", self, source)
