extends Spatial



signal playerSpawned
var spawnPoints = []
var playerCount = 0

func _ready():
	for child in get_children():
		spawnPoints.append(child.translation)
	while(self.get_child_count()>0):
		self.remove_child(self.get_child(0))
	self.connect("playerSpawned", Network, "_player_spawned")


func _process(delta):
	var toPrint = ""
	for child in get_children():
		toPrint += child.name + "\n"
	get_node("../Label").text = toPrint

func _setup_players():
	for playerIdx in Network.players:
		addPlayer(playerIdx)
	
	emit_signal("playerSpawned")

remote func addPlayer(playerIdx):
	print("addplayer :", playerIdx," dic : ", Network.players[playerIdx])
	var toAdd = load("res://src/world/player/tank.tscn").instance()
	toAdd.id = Network.players[playerIdx].net_id
	toAdd.name = "Player" + str(Network.players[playerIdx].net_id)
	self.add_child(toAdd)
	toAdd.master_translation = spawnPoints[playerCount]
	toAdd.translation = spawnPoints[playerCount]
	toAdd.connect("dead",self,"set_dead_camera")
	print(toAdd.translation)
	playerCount += 1
	update_camera()

remote func update_camera():
	for child in get_children():
		if child.is_in_group("player"):
			child.update_camera()

remote func set_dead_camera(id):
	if id == Gamestate.player_info.net_id:
		get_parent().get_node("Camera").current = true
		get_parent().get_node("Camera/SpawnButton").disabled = false
		get_parent().get_node("Camera/SpawnButton").visible = true


func update_newcomer(net_id):
	var toAdd = []
	for child in get_children():
		toAdd.append({"filename" : child.filename, "name" : child.name})
	rpc_id(net_id, "welcome", toAdd)



remote func welcome(toAddArray):
	for toAddDict in toAddArray:
		if not self.has_node(toAddDict.name):
			var toAdd = load(toAddDict.filename).instance()
			toAdd.name  = toAddDict.name
			self.add_child(toAdd)
