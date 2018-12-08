extends Spatial

onready var camera = $Camera
onready var player = $"Śmiećgracz"

func _process(delta):
	camera.translation.x += (player.translation.x - camera.translation.x)/10