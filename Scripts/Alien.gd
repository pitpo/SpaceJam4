extends "res://Scripts/Enemy.gd"

var is_visible = false
var speed = 3
var velocity = Vector3()
var damage_cooldown = 0

func _ready():
	$Alien/AnimationPlayer.playback_speed = 3
	$Alien/AnimationPlayer.get_animation("Walk").loop = true

func _physics_process(delta):
	if is_visible:
		if $Alien/AnimationPlayer.current_animation != "ArmatureAction":
			if abs(System.player.translation.x - translation.x) > 1 || abs(System.player.translation.y - translation.y) > 0.5:
				var player_direction = sign(System.player.translation.x - translation.x)
				velocity.x = player_direction
				velocity.z = sign(System.player.translation.z - translation.z)
				velocity = velocity.normalized()
				velocity += Vector3.DOWN * 30 * delta
				if player_direction < 0 && rotation_degrees.y > -90:
					rotation_degrees.y -= delta * 300 * speed
				elif player_direction > 0 && rotation_degrees.y < 90:
					rotation_degrees.y += delta * 300 * speed
				move_and_slide(velocity * speed, Vector3.UP)
			else:
				$Alien/AnimationPlayer.play("ArmatureAction")
				$CollisionShape/AnimationPlayer.play("attac")
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
	is_visible = true

func on_camera_exited(camera):
	is_visible = false

func slowdown_activated():
	speed = 3

func slowdown_disabled():
	speed = 1.5

func on_animation_finished(anim_name):
	rotation_degrees.y = sign(System.player.translation.x - translation.x) * 90
	if anim_name == "ArmatureAction":
		$Alien/AnimationPlayer.play("Walk")
