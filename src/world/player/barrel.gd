extends Spatial

onready var bulletRes = preload("res://src/world/player/bullet.tscn")


var timerFinished = true
onready var parent = get_parent().get_parent().get_parent()

var numberOfParticleSystems = 4

func _ready():
	
	for i in range(numberOfParticleSystems-1):
		var toAdd = $muzzleFire0.duplicate()
		self.add_child(toAdd)
		toAdd.name = "muzzleFire" + str(i+1)
		toAdd = ($muzzleSmoke0.duplicate())
		toAdd.name = "muzzleSmoke" + str(i+1)
		self.add_child(toAdd)
	



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
	var toDot = get_parent().global_transform.basis.xform(Vector3.FORWARD)
	var speedIncr = (parent.velocity as Vector3).dot(toDot)
	toAdd.speed += speedIncr
	
	
	timerFinished = false
	$Tween.interpolate_property($closeMf, "light_energy",32,0,0.5,Tween.TRANS_CUBIC)
	$Tween.start()
	$Tween.interpolate_property($farMf, "light_energy",16,0,0.2,Tween.TRANS_CUBIC)
	$Tween.start()
	$Tween.interpolate_property($barrel, "translation",Vector3.FORWARD,Vector3.ZERO,0.5,Tween.TRANS_BOUNCE)
	$Tween.start()
	var baseTrans = self.translation
	$Tween.interpolate_property(self, "translation",baseTrans - 0.5 * Vector3.FORWARD, baseTrans, 1.0,Tween.TRANS_BOUNCE)
	$Tween.start()
	$Tween.interpolate_property(parent, "SPEED",parent.SPEED - speedIncr/2, parent.SPEED, 1.0, Tween.TRANS_CUBIC)
	particleEmit("muzzleFire")
	particleEmit("muzzleSmoke")
	$Timer.start(1.0)

var particleIdx = 0
func particleEmit(emitterStr):
	get_node(emitterStr + str(particleIdx)).emitting = true
	particleIdx = (particleIdx + 1 )%numberOfParticleSystems



func _on_Timer_timeout():
	timerFinished = true
