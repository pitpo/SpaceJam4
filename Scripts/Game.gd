extends Spatial

onready var camera = $Camera
onready var player = $Player

var layer = 0

func _process(delta):
	camera.translation.x += (player.translation.x - camera.translation.x)/10