extends Spatial



signal playerSpawned
var spawnPoints = []


func _ready():
	for child in get_children():
		spawnPoints.append(child.translation)
	while(self.get_child_count()>0):
		self.remove_child(self.get_child(0))
	self.connect("playerSpawned", Network, "_player_spawned")
	print("adding players")
	var playerCount = 0
	for playerIdx in Network.players:
		print(playerIdx)
		var toAdd = load("res://src/world/player/tank.tscn").instance()
		toAdd.id = Network.players[playerIdx].net_id
		toAdd.name = "Player" + str(Network.players[playerIdx].net_id)
		self.add_child(toAdd)
		toAdd.master_translation = spawnPoints[playerCount]
		toAdd.translation = spawnPoints[playerCount]
		toAdd.connect("dead",self,"set_dead_camera")
		print(toAdd.translation)
		playerCount += 1
	emit_signal("playerSpawned")


remote func update_camera():
	for player in get_children():
		player.update_camera()

remote func set_dead_camera(id):
	if id == Gamestate.player_info.net_id:
		get_parent().get_node("Camera").current = true
