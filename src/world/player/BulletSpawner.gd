extends Spatial

func _ready():
	$rcastBase/rcastShower.set_surface_material(0, $rcastBase/rcastShower.get_surface_material(0).duplicate())

func set_dist(dist):
	$rcastBase.scale.y = dist
	$rcastBase/rcastShower.get_surface_material(0).set_shader_param("divider",dist)

func _process(delta):
	if $RayCast.is_colliding():
		var dist = ($RayCast.get_collision_point() - self.global_transform[3]).length()/2
		set_dist(dist)
		if not $RayCast.get_collider() == null:
			if $RayCast.get_collider().is_in_group("damageable"):
				$rcastBase/rcastShower.get_surface_material(0).set_shader_param("color",Color.red)
			else:
				$rcastBase/rcastShower.get_surface_material(0).set_shader_param("color",Color.yellow)
	else:
		$rcastBase/rcastShower.get_surface_material(0).set_shader_param("color",Color.yellow)
		set_dist($RayCast.cast_to.y)
