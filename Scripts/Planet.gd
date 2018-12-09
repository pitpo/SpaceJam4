extends Spatial

func _process(delta):
	translation.z = sin(OS.get_ticks_msec() * 0.0003)  * 120
	translation.y = cos(OS.get_ticks_msec() * 0.0003)  * 120
	rotation.y += delta