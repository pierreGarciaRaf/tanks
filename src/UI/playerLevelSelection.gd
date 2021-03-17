extends Control



func _ready():
	if Gamestate.player_info.net_id != 1:
		disable_buttons()

func disable_buttons():
	$Panel/StartGame.disabled = true
	$Panel/levelDisplayer/Next.disabled = true
	$Panel/levelDisplayer/Previous.disabled = true

func _on_StartGame_pressed():
	if Gamestate.player_info.net_id == 1:
		Network.coordinate_start_game($Panel/levelDisplayer.toLoad)


func update_newcomer(id):
	print(self," welcoming ",id)
	$Panel/levelDisplayer.update_newcomer(id)
