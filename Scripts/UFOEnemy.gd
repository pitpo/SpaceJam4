extends "res://Scripts/Enemy.gd"

var is_visible = false
var velocity = Vector3()
var speed = 2

func _physics_process(delta):
	if is_visible:
		var nearest_floor = $RayCast.get_collider()
		print(nearest_floor)
		if nearest_floor:
			translation.y = nearest_floor.translation.y + 1.5 + sin(OS.get_ticks_msec()*0.001)
		velocity.x = sign(System.player.translation.x - translation.x) * speed
		move_and_slide(velocity, Vector3.UP)
	else:
		velocity = Vector3()

func on_camera_entered(camera):
	is_visible = true

func on_camera_exited(camera):
	is_visible = false

func slowdown_activated():
	speed = 1

func slowdown_disabled():
	speed = 2