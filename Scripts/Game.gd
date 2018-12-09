extends Spatial

onready var paralax = $"../../../ParallaxBackground"
onready var camera = $Camera
onready var player = $Player
onready var ui = $"../../../UI"

func _init():
	System.game = self
	System.slow_down = false

func _ready():
	camera.translation.x = player.translation.x
	
	if System.save:
		System.player.translation = System.save[0]
		System.game.ui.crowns = System.save[1]
		System.player.crowns = System.save[2]
		System.player.get_node("Crown").visible = true

func _process(delta):
	camera.translation.x += (player.translation.x - camera.translation.x)/10
	camera.translation.y += (player.translation.y + 7.5 - camera.translation.y)/10
	camera.translation.x = max(camera.translation.x, -40)
	camera.translation.y = max(camera.translation.y, 6)
	paralax.get_child(1).motion_offset.x = -camera.translation.x * 10 - 600
	paralax.get_child(2).motion_offset.x = -camera.translation.x * 20