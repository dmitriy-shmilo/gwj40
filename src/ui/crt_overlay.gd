extends CanvasLayer

onready var _overlay_rect: ColorRect = $"OverlayRect"

func _ready() -> void:
	var size = Vector2(
		ProjectSettings.get_setting("display/window/size/width"),
		ProjectSettings.get_setting("display/window/size/height")
	)
	_overlay_rect.rect_size = size
	_overlay_rect.material.set_shader_param("screen_size", size)
