extends Node
class_name Gui

signal dialog_hidden
signal dialog_shown

onready var _dialog_tween: Tween = $"DialogTween"
onready var _dialog_container: Panel = $"DialogContainer"
onready var _dialog_text: RichTextLabel = $"DialogContainer/Text"
onready var _dialog_inventory: HBoxContainer = $"DialogContainer/Inventory"

onready var _cash_label: Label = $"Hud/CashLabel"
onready var _inventories: = [
	$"Hud/Character1/Inventory",
	$"Hud/Character2/Inventory"
]

onready var _pause_container: ColorRect = $"PauseContainer"


func _ready() -> void:
	_dialog_container.modulate.a = 0.0


func pause() -> void:
	_pause_container.visible = true


func unpause() -> void:
	_pause_container.visible = false


func update_cash(current: float) -> void:
	_cash_label.text = "$%0.2f" % current


func update_inventory(index: int, inventory: Array) -> void:
	_set_inventory(_inventories[index], inventory)


# TODO: pass portrait somehow
func show_dialog(text: String, items: Array) -> void:
	_dialog_text.text = tr(text)
	_set_inventory(_dialog_inventory, items)
	_dialog_tween.stop_all()
	_dialog_tween.interpolate_property(_dialog_container, "modulate:a", _dialog_container.modulate.a, 1.0, 0.25)
	_dialog_tween.start()
	emit_signal("dialog_shown")


func hide_dialog() -> void:
	_dialog_tween.stop_all()
	_dialog_tween.interpolate_property(_dialog_container, "modulate:a", _dialog_container.modulate.a, 0.0, 0.25)
	_dialog_tween.start()
	emit_signal("dialog_hidden")


func _set_inventory(container: HBoxContainer, inventory: Array) -> void:
	var pictures = container.get_children()
	
	for i in range(pictures.size()):
		if i >= inventory.size():
			pictures[i].visible = false
			pictures[i].texture.region.position.x = 0
			continue
		pictures[i].visible = true
		pictures[i].texture.region.position.x = inventory[i].sprite_frame * 8


func _on_DialogContainer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		hide_dialog()
