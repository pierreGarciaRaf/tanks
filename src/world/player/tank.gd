extends KinematicBody

export var id = -1

puppet var master_translation


puppet var velocity = Vector3.ZERO
const GRAVITY = 50.0
puppet var yaw = 0


var SPEED = 20.0
var JUMP_FORCE = 20.0


var forwardMomentum = 0.0
var rotationSpeed = 1.0
var accSpeed = 2.0
var deccSpeed = 4.0

signal dead


func _ready():
	master_translation = self.translation
	print("player added")
	self.connect("dead",Network,"_on_player_dead")



var lastYaw = 0
func _physics_process(delta):
	if Gamestate.player_info.net_id != 1:
		self.translation = master_translation
	else:
		var input = Gamestate.get_my_input(id)
		if input.should_kill_myself:
			rpc("destroy")
			destroy()
		var movementInput = (input.movement as Vector3)
		var xyInput = (movementInput)
		velocity += Vector3.DOWN * GRAVITY * delta
		if abs(xyInput.dot(Vector3.FORWARD)) < 0.3:
			forwardMomentum -= sign(forwardMomentum) * deccSpeed * delta * min(abs(forwardMomentum),1.0)
		else:
			forwardMomentum += xyInput.dot(Vector3.FORWARD) * accSpeed * delta
		
		
		forwardMomentum = clamp(forwardMomentum,-1,1)
		yaw -= xyInput.x * rotationSpeed * delta
		velocity = (SPEED * forwardMomentum * Vector3.FORWARD).rotated(Vector3.UP, yaw) + Vector3.UP * velocity.y
		
		
		rset("velocity",self.velocity)
		rset("master_translation", self.translation)
		rset("yaw", self.yaw)
	velocity = self.move_and_slide(velocity, Vector3.UP)
	update_body()
	lastYaw = yaw

func update_body():
	$body.rotation = Vector3.ZERO
	$body.rotate(Vector3.UP, yaw)
	
	$CollisionShape.rotation = Vector3.ZERO
	$CollisionShape.rotate(Vector3.UP, yaw)
	var flatVel = Vector2(velocity.x,velocity.z)
	$body/caterpillar.translation = max(flatVel.length()/SPEED*0.3, 0.2 if yaw != lastYaw else 0.0)*(Vector3.ONE * .5 - Vector3(randf(),randf(),randf()))
	$body/body.translation = flatVel.length()/SPEED*0.1*(Vector3.ONE * .5 - Vector3(randf(),randf(),randf()))
	

func update_camera():
	if id == Gamestate.player_info.net_id:
		$cameraTarget/Camera.current = true
	else:
		$cameraTarget/Camera.current = false


func deal_damage():
	if Gamestate.player_info.net_id == 1:
		rpc("destroy")
		destroy()


remote func destroy():
	emit_signal("dead",id)
	queue_free()
