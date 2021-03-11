extends Node
var player_info = {
	name = "Player",                   # How this player will be shown within the GUI
	net_id = 1,                        # By default everyone receives "server ID"
	ready_to_start_game = false
}
var inputPlayersQueue = {}

var sensitivity = 2e-3
var mousePosition = Vector2.ZERO
var hasClicked = false
func _ready():
	
	Network.connect("player_list_changed",self,"_on_player_list_changed")

func _process(delta):
	if Network.onAServer:
		if not player_info.net_id == 1:
			update_server()

func _input(event):
	if event is InputEventMouseMotion:
	   mousePosition = event.position
	elif event is InputEventMouseButton:
		hasClicked = (event as InputEventMouseButton).is_pressed()

func update_server():
	rpc_id(1, "queue_input", gen_input(), player_info.net_id)


func gen_blank_input():
	var res = {}
	res["movement"] = Vector3.ZERO
	res["mouse_position"] = Vector2.ZERO
	res["mouse_click"] = true
	res["should_kill_myself"] = false
	return res

func gen_suicide_input():
	var res = {}
	res["movement"] = Vector3.ZERO
	res["mouse_position"] = Vector2.ZERO
	res["mouse_click"] = false
	res["should_kill_myself"] = true
	return res

func gen_input():
	var res = {}
	var move = Vector3.FORWARD * (int(Input.is_action_pressed("move_front")) - int(Input.is_action_pressed("move_back")))
	move += Vector3.RIGHT * (int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")))
	res["movement"] = move
	res["mouse_position"] = mousePosition
	res["mouse_click"] = hasClicked
	res["should_kill_myself"] = false
	return res

func get_my_input(net_id):
	if net_id == 1:
		return gen_input()
	else:
		if inputPlayersQueue.has(net_id):
			return inputPlayersQueue[net_id]
		elif net_id < 0:
			return gen_blank_input()
		else:
			return gen_suicide_input()







remote func queue_input(input,id):
	inputPlayersQueue[id]= input


func _on_player_list_changed():
	inputPlayersQueue = {}
	for playerIdx in Network.players:
		inputPlayersQueue[playerIdx] = {}
