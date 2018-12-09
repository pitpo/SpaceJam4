extends KinematicBody

onready var animator = $"Scene Root/AnimationPlayer"

var mode = "appear"
var walk = -1

func _ready():
	animator.get_animation("Walk").loop = true
	
	animator.play("Slideer")

func _physics_process(delta):
	var motion = Vector3()
	
	match mode:
		"walk":
			motion.x += walk*2
			
			if abs(translation.x - System.player.translation.x) > 15:
				walk = -1
			elif abs(translation.x - System.player.translation.x) < 2:
				walk = 1
			if randi() % 100 == 0:
				walk *= -1
			
			if randi() % 300 == 0:
				mode = "attack"
				animator.playback_speed = 1
				
				if abs(translation.x - System.player.translation.x) < 4:
					animator.play("Spike")
					$AnimationPlayer.play("Rachu Ciachu")
				else:
					animator.play("tfu")
	
	move_and_slide(motion)

func on_animation_end(anim_name):
	if anim_name == "Slideer":
		System.reparent($Nitka, get_parent())
		
		animator.playback_speed = 4
		animator.play("Walk")
		mode = "walk"
	elif anim_name == "tfu":
		var tfu = preload("res://Nodes/SpiderTfu.tscn").instance()
		get_parent().add_child(tfu)
		tfu.translation = translation + Vector3(-1, 1, 0)
		
		animator.playback_speed = 4
		animator.play("Walk")
		mode = "walk"

func on_attacked(body):
	if body == System.player:
		body.damage()