extends Control
#127.0.0.1
#localhost
#MacBook-Air-de-Pierre.local
#192.168.1.27

func _ready():
	Network.connect("server_created", self, "_on_started_to_host")
	Network.connect("join_success", self, "_on_server_joined")

func _on_started_to_host():
	$PreGameServerPanel.visible = true
	$NetworkSelectionPanel.visible = false

func _on_server_joined():
	
	$PreGameClientPanel.visible = true
	$NetworkSelectionPanel.visible = false


func _on_host_pressed():
	Gamestate.player_info.name = $NetworkSelectionPanel/PlayerName.text
	Network.create_server()


func _on_join_pressed():
	Gamestate.player_info.name = $NetworkSelectionPanel/PlayerName.text
	Network.join_server($NetworkSelectionPanel/serverIP.text)


func _on_Start_pressed():
	print("start pressed")
	Network.coordinate_start_game()


func _on_port_text_changed(new_text):
	Network.server_info.used_port = int(new_text)
