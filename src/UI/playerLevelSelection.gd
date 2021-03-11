extends Control





func _on_StartGame_pressed():
	Network.coordinate_start_game($Panel/levelDisplayer.toLoad)
