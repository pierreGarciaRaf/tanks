extends Control
onready var parentID = get_parent().get_parent().get_parent().id

func _ready():
	if Network.players.has(parentID):
		get_child(0).text = Network.players[parentID].name
	else:
		get_child(0).text = "blank"

func set_pos(newPos):
	self.anchor_left = newPos.x
	self.anchor_right = newPos.x
	self.anchor_bottom = newPos.y
	self.anchor_top = newPos.y

func _process(_delta):
	var curCamera = get_viewport().get_camera()
	var posToGetTo = curCamera.unproject_position(get_parent().global_transform[3])/get_viewport().get_visible_rect().size
	set_pos(posToGetTo)
