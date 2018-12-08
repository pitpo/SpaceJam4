extends "res://Scripts/Enemy.gd"

var is_visible = false
var velocity = Vector3()
var speed = 2

func _physics_process(delta):
	if is_visible:
		var nearest_floor = $RayCast.get_collider()
		if nearest_floor:
			var dest_y = nearest_floor.translation.y + 2.5 + sin(OS.get_ticks_msec()*0.003) * 0.65
			velocity.y = dest_y - translation.y
		else:
			velocity.y = 0
		var player_direction = sign(System.player.translation.x - translation.x)
		velocity.x = player_direction
		velocity.z = sign(System.player.translation.z - translation.z)
		if player_direction < 0 && rotation_degrees.y > -90:
			rotation_degrees.y -= delta * 300
		elif player_direction > 0 && rotation_degrees.y < 90:
			rotation_degrees.y += delta * 300
		move_and_slide(velocity.normalized() * speed, Vector3.UP)
		
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