extends Node

signal server_created                          # when server is successfully created
signal join_success                            # When the peer successfully joins a server
signal join_fail                               # Failed to join a server
signal player_list_changed                     # List of players has been changed
signal player_disconnected #a player quit the game




var server_info = {
	name = "Server",      # Holds the name of the server
	max_players = 4,      # Maximum allowed connections
	used_port = 4546         # Listening port
}

var actualNet
var players = {}
var onAServer = false



func _ready():
	get_tree().connect("network_peer_connected", self, "_on_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	get_tree().connect("server_disconnected", self, "_on_disconnected_from_server")



# Everyone gets notified whenever a new client joins the server
func _on_player_connected(id):
	print(id)



# Everyone gets notified whenever someone disconnects from the server
func _on_player_disconnected(id):
	print("Player ", players[id].name, " disconnected from server")
	# Update the player tables
	if (get_tree().is_network_server()):
		# Unregister the player from the server's list
		unregister_player(id)
		# Then on all remaining peers
		rpc("unregister_player", id)
		
		emit_signal("player_disconnected",id)


# Peer trying to connect to server is notified on success
func _on_connected_to_server():
	rpc_id(1,"server_coordinate_register_player",Gamestate.player_info)
	emit_signal("join_success")
	onAServer = true
	print("connected ",Gamestate.player_info)





# Peer trying to connect to server is notified on failure
func _on_connection_failed():
	emit_signal("join_fail")
	get_tree().set_network_peer(null)
	print("connection failed")


# Peer is notified when disconnected from server
func _on_disconnected_from_server():
	get_tree().set_network_peer(null)
	get_tree().change_scene("res://src/UI/serverDisconnected.tscn")
	


func _on_started_to_host():
	print("started to host")









func create_server():
	# Initialize the networking system
	var net = NetworkedMultiplayerENet.new()
	
	# Try to create the server
	var server_creation_info = net.create_server(server_info.used_port, server_info.max_players)
	if (server_creation_info != OK):
		print("Failed to create server, ",server_creation_info)
		return
	
	# Assign it into the tree
	get_tree().set_network_peer(net)
	register_player(Gamestate.player_info)
	emit_signal("server_created")


func join_server(ip):
	var net = NetworkedMultiplayerENet.new()
	
	if (net.create_client(ip, int(server_info.used_port)) != OK):
		print("Failed to create client")
		emit_signal("join_fail")
		return false
	print("created client")
	get_tree().set_network_peer(net)
	Gamestate.player_info.net_id = net.get_unique_id()
	return true



remote func changeScene(toWhat):
	if get_tree().current_scene.filename != toWhat:
		get_tree().change_scene(toWhat)
		rpc_id(1, "ready_to_get_welcomed", Gamestate.player_info.net_id)

remote func ready_to_get_welcomed(id):
	print(get_tree().current_scene.name)
	if get_tree().current_scene.is_in_group("wellcoming"):
		get_tree().current_scene.update_newcomer(id)

remote func server_coordinate_register_player(pinfo):
	if Gamestate.player_info.net_id == 1:
		rpc_id(pinfo.net_id, "changeScene", get_tree().current_scene.filename)
		for playerIdx in players:
			rpc_id(pinfo.net_id, "register_player", players[playerIdx])
		rpc("register_player",pinfo)
		register_player(pinfo)


remote func register_player(pInfo):
	players[pInfo.net_id] = pInfo
	emit_signal("player_list_changed")
	print(players)

remote func unregister_player(id):
	print("Removing player ", players[id].name, " from internal table")
	# Remove the player from the list
	players.erase(id)
	# And notify the list has been changed
	emit_signal("player_list_changed")

func update_player(net_id, key, new_value):
	(players[net_id] as Dictionary)[key] = new_value




func coordinate_map_selection():
	rpc("map_selection")
	map_selection()


remote func map_selection():
	get_tree().change_scene("res://src/UI/playerLevelSelection.tscn")

func coordinate_start_game(toLoad):
	rpc("start_game",toLoad)
	start_game(toLoad)


remote func start_game(toLoad):
	var loadedScene = load(toLoad)
	get_tree().change_scene_to(loadedScene)



remote func player_ready(net_id):
	update_player(net_id, "ready_to_start_game", true)
	for playerNetId in players:
		if !players[playerNetId].ready_to_start_game:
			return
	coordinate_camera_currents()

func _player_spawned():
	if Gamestate.player_info.net_id == 1:
		player_ready(1)
	else:
		rpc_id(1,"player_ready",Gamestate.player_info.net_id)

func coordinate_camera_currents():
	get_node("/root").print_tree_pretty()
	get_node("/root/world/playersContainer").rpc("update_camera")
	get_node("/root/world/playersContainer").update_camera()


func _on_player_dead(playerId):
	if playerId == Gamestate.player_info.net_id:
		print("I'm dead")
	else:
		if players.has(playerId):
			print(players[playerId].name +str(" died."))
		else:
			print("blank died.")

func server_coordinate_receive_boost(id,toReceive):
	if receive_boost(id,toReceive):
		rpc("receive_boost",id,toReceive)
	print(players)

remote func receive_boost(id,toReceive):
	if players[id].bonuses.has(toReceive):
		return false
	(players[id].bonuses as Array).append(toReceive)
	return true






