extends "res://Scripts/Enemy.gd"

var speed = 3

func _physics_process(delta):
	move_and_slide(Vector3.RIGHT * speed, Vector3.UP)

func slowdown_activated():
	speed = 1

func slowdown_disabled():
	speed = 3