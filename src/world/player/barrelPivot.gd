extends Spatial

puppet var master_rotation = 1.0
const ROT_SPEED = 3.0

onready var parent = get_parent().get_parent()

var angularVel = 0.0






func _physics_process(delta):
	if Gamestate.player_info.net_id == 1:
		var input = Gamestate.get_my_input(parent.id)
		var toLookAt = parent.get_node("cameraTarget/Camera").project_frow_view_on_y_plane(input.mouse_position, $head/BulletSpawner.translation.y)
		
		
		var oldRot = -(self.rotation.y + get_parent().rotation.y - PI/2)
		var globalTrans = self.global_transform[3]
		var rotToGetTo = atan2(toLookAt.z - globalTrans.z, toLookAt.x - globalTrans.x) + (oldRot - fmod(oldRot,2*PI))
		var possibleRots = [rotToGetTo - 2*PI, rotToGetTo, rotToGetTo + 2*PI]
		var possibleDistances = [	abs(possibleRots[0] - oldRot),
									abs(possibleRots[1] - oldRot),
									abs(possibleRots[2] - oldRot)]
		var argmin = argmin(possibleDistances)
		var decidedRot = possibleRots[argmin]
		
		var direction = sign(decidedRot - oldRot)
		var distance = abs (possibleDistances[argmin] - PI)
		self.rotation.y = self.rotation.y + direction * delta * min(distance,1) * ROT_SPEED
		rset("master_rotation", self.rotation.y)
	else:
		self.rotation.y = master_rotation


func argmin(valArray):
	var idx = 0
	var valmin = valArray[0]
	var argmin = 0
	for val in valArray :
		if val < valmin :
			valmin = val
			argmin = idx
		idx+=1
	return argmin
