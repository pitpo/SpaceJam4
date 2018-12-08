extends "res://Scripts/Enemy.gd"

var is_visible = false
var velocity = Vector3()

func _physics_process(delta):
	if is_visible:
		var nearest_floor = $RayCast.get_collider()
		print(nearest_floor)
		if nearest_floor:
			translation.y = nearest_floor.translation.y + 1.5 + sin(OS.get_ticks_msec()*0.001)
			
	else:
		velocity = Vector3()

func on_camera_entered(camera):
	is_visible = true

func on_camera_exited(camera):
	is_visible = false
