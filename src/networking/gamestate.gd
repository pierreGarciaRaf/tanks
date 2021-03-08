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


func gen_input():
	var res = {}
	var move = Vector3.FORWARD * (int(Input.is_action_pressed("move_front")) - int(Input.is_action_pressed("move_back")))
	move += Vector3.RIGHT * (int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")))
	res["movement"] = move
	res["mouse_position"] = mousePosition
	res["mouse_click"] = hasClicked
	return res

func get_my_input(net_id):
	if net_id == 1:
		return gen_input()
	else:
		return inputPlayersQueue[net_id]







remote func queue_input(input,id):
	inputPlayersQueue[id]= input


func _on_player_list_changed():
	inputPlayersQueue = {}
	for playerIdx in Network.players:
		inputPlayersQueue[playerIdx] = {}
