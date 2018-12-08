extends RigidBody

var boomerang_speed

func boomerang():
	System.reparent(self, System.game)
	$Boomerang.play("Rotate")
	boomerang_speed = 10

func throw():
	System.reparent(self, System.game)
	mode = RigidBody.MODE_RIGID

func _physics_process(delta):
	if boomerang_speed != null:
		if boomerang_speed > 0:
			translation.x += boomerang_speed * delta
			boomerang_speed -= delta * 10
		else:
			var to_target = ((System.player.global_transform.origin + System.player.crown_origin) - global_transform.origin)
			
			if to_target.length_squared() < 0.2:
				System.reparent(self, System.player)
				translation = System.player.crown_origin
				boomerang_speed = null
				$Boomerang.stop()
			else:
				translation += to_target.normalized() * 10 * delta