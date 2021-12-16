extends VBoxContainer



func _on_QuitButton_pressed():
	get_tree().change_scene("res://title_screen/title_screen.tscn")


func _on_RetryButton_pressed():
	get_tree().change_scene("res://day_screen/day_screen.tscn")
