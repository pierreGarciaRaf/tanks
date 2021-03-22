extends Control




func _on_quit_pressed():
	get_tree().quit(0)


func _on_backToMenu_pressed():
	get_tree().change_scene("res://src/UI/mainMenu.tscn")
