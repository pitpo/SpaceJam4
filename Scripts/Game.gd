extends Spatial

onready var camera = $CameraRail
onready var player = $Player

var layer = 0

func _process(delta):
	camera.translation.x += (player.translation.x - camera.translation.x)/10
	
	camera.get_child(0).translation.z = lerp(10, -10, -player.translation.z/4)
	camera.get_child(0).translation.x = -sin(-player.translation.z/4 * PI) * 10
	camera.get_child(0).look_at(player.translation, Vector3.UP)