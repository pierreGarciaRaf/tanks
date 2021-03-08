extends Control



func _ready():
	Network.connect("player_list_changed",self, "update_player_list")

func update_player_list():
	while get_child_count() > 0:
		self.remove_child(self.get_child(0))
	for playerIdx in Network.players:
		var toAdd = Label.new()
		toAdd.text = Network.players[playerIdx].name
		self.add_child(toAdd)
