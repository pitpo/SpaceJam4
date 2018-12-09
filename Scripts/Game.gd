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

func _process(delta):
	camera.translation.x += (player.translation.x - camera.translation.x)/10
	paralax.get_child(1).motion_offset.x = -camera.translation.x * 10
	paralax.get_child(2).motion_offset.x = -camera.translation.x * 20