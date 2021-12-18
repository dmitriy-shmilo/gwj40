extends Node
class_name Gui

const SELECTED_ALPHA = 0.8
const DESELECTED_ALPHA = 0.55

signal dialog_hidden
signal dialog_shown

onready var _dialog_tween: Tween = $"DialogTween"
onready var _dialog_container: Panel = $"DialogContainer"
onready var _dialog_text: RichTextLabel = $"DialogContainer/Text"
onready var _dialog_inventory: InventoryGui = $"DialogContainer/Inventory"
onready var _time_progress: TextureProgress = $"Hud/TimeProgress"
onready var _cash_label: Label = $"Hud/CashLabel"

onready var _characters: = [
	$"Hud/Character1",
	$"Hud/Character2"
]
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
	_inventories[index].set_items(inventory)


# TODO: pass portrait somehow
func show_dialog(text: String, items: Array) -> void:
	_dialog_text.text = tr(text)
	_dialog_inventory.set_items(items)
	_dialog_tween.stop_all()
	_dialog_tween.interpolate_property(_dialog_container, "modulate:a", _dialog_container.modulate.a, 1.0, 0.25)
	_dialog_tween.start()
	emit_signal("dialog_shown")


func hide_dialog() -> void:
	_dialog_tween.stop_all()
	_dialog_tween.interpolate_property(_dialog_container, "modulate:a", _dialog_container.modulate.a, 0.0, 0.25)
	_dialog_tween.start()
	emit_signal("dialog_hidden")


func update_time_progress(current: float, total: float) -> void:
	_time_progress.max_value = total
	_time_progress.value = current


func select_character(index: int) -> void:
	_characters[index].modulate.a = SELECTED_ALPHA


func deselect_character(index: int) -> void:
	_characters[index].modulate.a = DESELECTED_ALPHA


func _on_DialogContainer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		hide_dialog()
