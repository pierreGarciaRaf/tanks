extends Spatial


func update_newcomer(net_id):
	$playersContainer.update_newcomer(net_id)

func setup_players():
	$playersContainer._setup_players()



func _on_SpawnButton_pressed():
	$Camera/SpawnButton.visible = false
	$Camera/SpawnButton.disabled = true
	if Gamestate.player_info.net_id == 1:
		_server_coordinate_player_spawn(1)
	else:
		rpc_id(1,"_server_coordinate_player_spawn",Gamestate.player_info.net_id)

remote func _server_coordinate_player_spawn(id):
	spawn_player(id)
	rpc("spawn_player",id)


remote func spawn_player(id):
	$playersContainer.addPlayer(id)
