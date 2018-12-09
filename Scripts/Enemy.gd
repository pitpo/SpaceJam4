extends KinematicBody

var health = 0

func damage():
	if health > 0:
		health -= 1
	if health == 0:
		die()

func die():
	pass