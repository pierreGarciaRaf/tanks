extends Camera

func project_frow_view_on_y_plane(mouse_pos : Vector2, planeHeight : float):
	var n = self.project_ray_normal(mouse_pos)
	var globTrans = self.global_transform[3]
	return globTrans - n * (globTrans.y - planeHeight) / n.y

func project_frow_view_on_collision(mouse_pos : Vector2):
	$RayCast.cast_to = 5 * $RayCast.global_transform.basis.xform_inv(self.project_position(mouse_pos, 50.0) - self.global_transform[3])
	return $RayCast.get_collision_point()

