extends Panel


var availableMaps = []
var toLoad = ""
puppet var levelIdx = 0


func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	if not dir.open(path) == OK:
		print("error at openning")
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files

func get_level_image(levelName):
	return load("res://src/world/levels/levelImages/" + levelName + ".PNG")


func _ready():
	for level in list_files_in_directory("res://src/world/levels/availableLevel/"):
		var splitted = (level as String).split(".")
		availableMaps.append({"path" : "res://src/world/levels/availableLevel/"+level, "name" : splitted[0], "playerNb" : int( splitted[1] ),
		 "gamemode" : splitted[2], "imgRes" : get_level_image(splitted[0])})
	update_display_level()

remote func update_display_level():
	$levelName.text = availableMaps[levelIdx].name
	$levelPicture.texture = availableMaps[levelIdx].imgRes
	$gamemode.text = availableMaps[levelIdx].gamemode
	$playerNb.text = str(availableMaps[levelIdx].playerNb)
	toLoad = availableMaps[levelIdx].path


func _on_Next_pressed():
	levelIdx = (levelIdx + 1)%len(availableMaps)
	update_display_level()
	rset("levelIdx",levelIdx)
	rpc("update_display_level")


func _on_Previous_pressed():
	levelIdx = (levelIdx - 1)%len(availableMaps)
	update_display_level()
	rset("levelIdx",levelIdx)
	rpc("update_display_level")


func update_newcomer(id):
	rset_id(id, "levelIdx", levelIdx)
	rpc_id(id, "update_display_level")
