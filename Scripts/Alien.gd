extends "res://Scripts/Enemy.gd"

var is_visible = false
var speed = 3
var velocity = Vector3()

func _physics_process(delta):
	if is_visible:
		if !$Alien/AnimationPlayer.is_playing():
			if abs(System.player.translation.x - translation.x) > 1:
				var player_direction = sign(System.player.translation.x - translation.x)
				velocity.x = player_direction
				velocity.z = sign(System.player.translation.z - translation.z)
				if player_direction < 0 && rotation_degrees.y > -90:
					rotation_degrees.y -= delta * 300 * speed
				elif player_direction > 0 && rotation_degrees.y < 90:
					rotation_degrees.y += delta * 300 * speed
				move_and_slide(velocity.normalized() * speed, Vector3.UP)
			else:
				$Alien/AnimationPlayer.play("ArmatureAction")
				$CollisionShape/AnimationPlayer.play("attac")
		else:
			rotation.y = -(Vector2(System.player.translation.x, System.player.translation.z) - Vector2(translation.x, translation.z)).rotated(-PI/2).angle()
			var hit = move_and_collide(Vector3())
			if hit != null && hit.collider == System.player:
				System.game.ui.hearts -= 1
	else:
		velocity = Vector3()

func on_camera_entered(camera):
	is_visible = true

func on_camera_exited(camera):
	is_visible = false

func slowdown_activated():
	speed = 3

func slowdown_disabled():
	speed = 1.5