extends "res://Scripts/Enemy.gd"

var is_visible = false
var speed = 3
var velocity = Vector3()
var damage_cooldown = 0
var dead_countdown = 0.3
var dead_countdown_helper = 0.3

func _ready():
	$Alien/AnimationPlayer.playback_speed = 3
	$Alien/AnimationPlayer.get_animation("Walk").loop = true
	health = 3

func _physics_process(delta):
	if health == 0:
		$CollisionShape.disabled = true
		$Alien/AnimationPlayer.playback_speed = 2 * System.time_scale()
		if !$Alien/AnimationPlayer.is_playing():
			dead_countdown -= delta
			if dead_countdown < 0:
				dead_countdown_helper /= 1.5
				dead_countdown = dead_countdown_helper
				visible = !visible
		if dead_countdown_helper < 0.05:
			queue_free()
		return
	if is_visible:
		$Alien/AnimationPlayer.playback_speed = 3 * System.time_scale()
		
		if $Alien/AnimationPlayer.current_animation != "ArmatureAction":
			if abs(System.player.translation.x - translation.x) > 1 || abs(System.player.translation.y - translation.y) > 0.5:
				var player_direction = sign(System.player.translation.x - translation.x)
				velocity.x = player_direction
				velocity.z = sign(System.player.translation.z - translation.z)
				velocity = velocity.normalized()
				velocity += Vector3.DOWN * 30 * delta
				if player_direction < 0 && rotation_degrees.y > -90:
					rotation_degrees.y -= delta * 300 * speed * System.time_scale()
				elif player_direction > 0 && rotation_degrees.y < 90:
					rotation_degrees.y += delta * 300 * speed * System.time_scale()
				move_and_slide(velocity * speed * System.time_scale(), Vector3.UP)
			else:
				$Alien/AnimationPlayer.play("ArmatureAction")
				$CollisionShape/AnimationPlayer.play("attac")
				$Attack.play()
				damage_cooldown = 0.6
		else:
			rotation.y = -(Vector2(System.player.translation.x, System.player.translation.z) - Vector2(translation.x, translation.z)).rotated(-PI/2).angle()
			damage_cooldown -= delta
			var hit = move_and_collide(Vector3())
			if damage_cooldown < 0 && hit != null && hit.collider == System.player:
				System.game.ui.health -= 1
				damage_cooldown = 0.6
	else:
		velocity = Vector3()

func on_camera_entered(camera):
	$Alien/AnimationPlayer.play("Walk")
	is_visible = true

func on_camera_exited(camera):
	is_visible = false

func on_animation_finished(anim_name):
	if health != 0:
		rotation_degrees.y = sign(System.player.translation.x - translation.x) * 90
	if anim_name == "ArmatureAction":
		$Alien/AnimationPlayer.play("Walk")

func die():
	rotation_degrees.y = 90
	$Alien/AnimationPlayer.play("death")
