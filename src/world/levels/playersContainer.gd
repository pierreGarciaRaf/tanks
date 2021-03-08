extends Spatial


signal playerSpawned

func _ready():
	self.connect("playerSpawned", Network, "_player_spawned")
	print("adding players")
	var playerCount = 0
	for playerIdx in Network.players:
		print(playerIdx)
		var toAdd = load("res://src/world/player/tank.tscn").instance()
		toAdd.id = Network.players[playerIdx].net_id
		toAdd.name = "Player" + str(Network.players[playerIdx].net_id)
		self.add_child(toAdd)
		toAdd.master_translation = playerIdx * Vector3.FORWARD * 5.0
		toAdd.translation = playerCount * Vector3.FORWARD * 5.0
		print(toAdd.translation)
		playerCount += 1
	emit_signal("playerSpawned")


remote func update_camera():
	for player in get_children():
		player.update_camera()
