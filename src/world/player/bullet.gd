extends Area

puppet var master_position = null

var speed = 30.0
var thrower




func _physics_process(delta):
	self.translation += self.transform.basis.xform(Vector3.FORWARD * speed) * delta
	if Gamestate.player_info.net_id == 1:
		rset("master_position",self.translation)
	elif master_position != null:
		self.translation = master_position
		

remote func remote_queue_free():
	self.queue_free()




func _on_bullet_body_entered(body):
	if not body == thrower:
		if body.is_in_group("damageable") :
			body.deal_damage()
		if Gamestate.player_info.net_id == 1:
			self.queue_free()
			rpc("remote_queue_free")
