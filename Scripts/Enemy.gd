extends KinematicBody

var slowdown = false

func _ready():
	System.connect("slowdown_switched", self, "slowdown_switch")


func slowdown_switch():
	slowdown = !slowdown
	if slowdown:
		slowdown_activated()
	else:
		slowdown_disabled()

func slowdown_activated():
	pass

func slowdown_disabled():
	pass