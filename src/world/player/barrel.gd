extends MeshInstance

onready var bulletRes = preload("res://src/world/player/bullet.tscn")


var timerFinished = true
onready var parent = get_parent().get_parent().get_parent()

func _physics_process(delta):
	if Gamestate.player_info.net_id == 1:
		var shotInput = Gamestate.get_my_input(parent.id).mouse_click
		if shotInput and timerFinished:
			shoot()
			rpc("shoot")


remote func shoot():
	var toAdd = bulletRes.instance()
	toAdd.thrower = parent
	parent.get_parent().add_child(toAdd)
	toAdd.global_transform = $BulletSpawner.global_transform
	toAdd.scale = Vector3.ONE
	toAdd.rotate_object_local(Vector3.RIGHT, PI/2)
	
	timerFinished = false
	$Tween.interpolate_property($closeMf, "light_energy",16,0,0.5,Tween.TRANS_CUBIC)
	$Tween.start()
	$Tween.interpolate_property($farMf, "light_energy",8,0,0.2,Tween.TRANS_CUBIC)
	$Tween.start()
	particleEmit("muzzleFire")
	particleEmit("muzzleSmoke")
	$Timer.start(1.0)


func particleEmit(emitterStr):
	var i = 0
	while(self.has_node(emitterStr+str(i))):
		i+=1
	i-=1
	if self.get_node(emitterStr+str(i)).emitting:
		print("emitting")
		i+=1
		var toAdd = get_node(emitterStr+str(0)).duplicate()
		toAdd.name = emitterStr + str(i)
		self.add_child(toAdd)
		toAdd.emitting = true
	else:
		print("not emitting")
		get_node(emitterStr+str(i)).emitting = true
	
	
	


func _on_Timer_timeout():
	timerFinished = true
