extends Node2D



func _on_InteractiveReceiver_interaction_finished(source) -> void:
	print("Got items: ", source.get_inventory())
