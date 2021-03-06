extends KinematicBody

onready var crown = $Crown
onready var crown_origin = $Crown.translation
onready var animator = $PlayerModel/AnimationPlayer

var crowns = 0

var velocity = Vector3()
var jump_strength = 10
var dir = 1
var jumping = false
var dead = false
var jetpack = false
var target_rotation = 90
var teleport_use_timeout = 0.6

var equipped_crown = System.CROWN.BOOMERANG

var was_on_floor = false

func _init():
	System.player = self

func _ready():
	animator.get_animation("Breathing").loop = true
	animator.get_animation("true_mid Jump").loop = true
	animator.play("Breathing")
	
	animator.playback_speed = 4
	animator.connect("animation_finished", self, "animation_end")
	
	if crowns == 0:
		$Crown.visible = false

func _process(delta):
	if dead: return
	
	if Input.is_action_just_pressed("player_crown_used"):
		use_crown()
	if Input.is_action_just_released("player_crown_used") and equipped_crown == System.CROWN.JETPACK:
		disable_jetpack()
	
	if crowns > 0:
		if Input.is_action_just_pressed("next_crown"):
			set_crown((equipped_crown + 1) % crowns)
		if Input.is_action_just_pressed("previous_crown"):
			set_crown(-1)
	
	if $RayCast.get_collider():
		$RayCast.visible = true
		$RayCast/Shade.global_transform.origin.y = $RayCast.get_collision_point().y+0.1
	else:
		$RayCast.visible = false
	
func _physics_process(delta):
	if dead: return
	
	if jetpack and $Crown/Crown4/Particles.visible:
		velocity += Vector3.UP * 10 * delta
		jetpack -= delta
		if jetpack < 0:
			jetpack = false
			$Crown/Crown4/Particles.visible = false
	else:
		velocity += Vector3.DOWN * 30 * delta
	
	velocity.x *= 0.9
	velocity.z *= 0.9
	
	var move_x = int(Input.is_action_pressed("player_move_right")) - int(Input.is_action_pressed("player_move_left"))
	var move_z = int(Input.is_action_pressed("player_move_backward")) - int(Input.is_action_pressed("player_move_forward"))
	velocity += Vector3(move_x, 0, move_z).normalized() * 0.85
	
	var walking = false
	if move_x > 0:
		dir = 1
		walking = true
	elif move_x < 0:
		dir = -1
		walking = true
	if move_x != 0 or move_z != 0: target_rotation = rad2deg(Vector2(move_z, move_x).angle())
	
	$PlayerModel.rotation_degrees.y += (target_rotation - $PlayerModel.rotation_degrees.y)/10
	
	teleport_use_timeout -= delta
	
	if Input.is_action_pressed("player_move_jump") and !jetpack and is_on_floor():
		$Jump.play()
		jumping = true
		velocity += Vector3.UP * jump_strength
		animator.play("start_jump")
	
	velocity = move_and_slide_with_snap(velocity, Vector3() if jumping or jetpack else Vector3.DOWN, Vector3.UP, true, 4, deg2rad(20))
	translation.z = clamp(translation.z, -4, 0)
	
	if is_on_floor():
		jumping = false
		jetpack = false
		
		if !was_on_floor:
			animator.play("end_jump")
		was_on_floor = true
	
		if walking and animator.current_animation != "Running" and animator.current_animation != "end_jump":
			animator.play("Running")
		elif !walking and animator.current_animation != "Breathing" and animator.current_animation != "end_jump":
			animator.play("Breathing")
	else:
		was_on_floor = false
	
	if translation.y < -10:
		System.game.ui.health = 0

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode >= 49 and event.scancode < 49 + crowns:
			set_crown(event.scancode - 49)

func set_crown(j):
	if !has_node("Crown") or crowns == 0: return
	
	if j < 0:
		equipped_crown -= 1
		if equipped_crown < 0: equipped_crown = crowns-1
	else:
		equipped_crown = j
	
	for i in crowns: $Crown.get_child(i).visible = (equipped_crown == i)

func use_crown():
	if crowns == 0: return
	match equipped_crown:
		System.CROWN.BOOMERANG:
			if has_node("Crown"):
				$Crown.boomerang(dir)
		System.CROWN.SLOWDOWN:
			if !System.slow_down:
				System.slow_down = 3
				$Crown/Crown3/Ice.play()
			else:
				System.slow_down = null
		System.CROWN.TELEPORTATION:
			jetpack = false
			if has_node("Crown") && teleport_use_timeout < 0:
				$Crown/Crown/BoomerangFlight.play()
				$Crown.throw(dir)
			elif teleport_use_timeout < 0:
				teleport_use_timeout = 1
				crown.teleport()
		System.CROWN.JETPACK:
			enable_jetpack()

func enable_jetpack():
	$Crown/Crown4/Particles.visible = true
	$Crown/Crown4/Fire.play()
	if !jetpack:
		jetpack = 1

func disable_jetpack():
	$Crown/Crown4/Particles.visible = false

func animation_end(anim):
	if anim == "start_jump":
		animator.play("true_mid Jump")
	elif anim == "end_jump":
		animator.play("Breathing")
	elif anim == "DIE":
		get_tree().change_scene("res://Scenes/GameOver.tscn")

func die():
	if !dead:
		animator.play("DIE")
		$Death.play()
		dead = true

func damage():
	System.game.ui.damage()