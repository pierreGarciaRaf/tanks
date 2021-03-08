extends KinematicBody

puppet var master_position = null

var speed = 0.5
var thrower




func _physics_process(delta):
	var coll = self.move_and_collide(self.transform.basis.xform(Vector3.FORWARD * speed))
	if Gamestate.player_info.net_id == 1:
		rset("master_position",self.translation)
		if coll:
			if coll.collider != thrower:
				rpc("remote_queue_free")
				self.queue_free()
	elif master_position != null:
		self.translation = master_position
		

remote func remote_queue_free():
	self.queue_free()
