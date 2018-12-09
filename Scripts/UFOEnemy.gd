extends "res://Scripts/Enemy.gd"

var is_visible = false
var velocity = Vector3()
var speed = 2
var time_to_shoot = 2

func _ready():
	health = 1

func _physics_process(delta):
	if health == 0:
		velocity += Vector3.UP * delta
		move_and_slide(velocity * speed * System.time_scale(), Vector3.UP)
		$Noise.unit_db -= 0.25
		if !is_visible:
			queue_free()
		return
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
			rotation_degrees.y -= delta * 150 * speed * System.time_scale()
		elif player_direction > 0 && rotation_degrees.y < 90:
			rotation_degrees.y += delta * 150 * speed * System.time_scale()
		if time_to_shoot < 0:
			var projectile = preload("res://Nodes/UFOProjectile.tscn").instance()
			projectile.translation = translation
			get_parent().add_child(projectile)
			$Gun.play()
			time_to_shoot = 2
		time_to_shoot -= delta * System.time_scale()
		move_and_slide(velocity.normalized() * speed * System.time_scale(), Vector3.UP)
		
	else:
		velocity = Vector3()

func on_camera_entered(camera):
	is_visible = true

func on_camera_exited(camera):
	is_visible = false