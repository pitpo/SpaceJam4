extends KinematicBody

onready var crown = $Crown
onready var crown_origin = $Crown.translation
onready var animator = $PlayerModel/AnimationPlayer

var velocity = Vector3()
var jump_strength = 8
var dir = 1
var jumping = false
var dead = false

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

func _process(delta):
	if Input.is_action_just_pressed("player_crown_used"):
		use_crown()

func _physics_process(delta):
	if dead: return
	velocity += Vector3.DOWN * 30 * delta
	velocity.x *= 0.9
	velocity.z *= 0.9
	
	var move_x = int(Input.is_action_pressed("player_move_right")) - int(Input.is_action_pressed("player_move_left"))
	var move_z = int(Input.is_action_pressed("player_move_backward")) - int(Input.is_action_pressed("player_move_forward"))
	velocity += Vector3(move_x, 0, move_z).normalized() * 0.85
	
	var walking = false
	if move_x > 0:
		$PlayerModel.rotation_degrees.y = 90
		dir = 1
		walking = true
	elif move_x < 0:
		$PlayerModel.rotation_degrees.y = -90
		dir = -1
		walking = true
	
	if Input.is_action_pressed("player_move_jump") and is_on_floor():
		jumping = true
		velocity += Vector3.UP * jump_strength
		animator.play("start_jump")
	
	velocity = move_and_slide_with_snap(velocity, Vector3() if jumping else Vector3.DOWN, Vector3.UP, true, 4, deg2rad(20))
	translation.z = clamp(translation.z, -4, 0)
	
	if is_on_floor():
		jumping = false
		if !was_on_floor:
			animator.play("end_jump")
		was_on_floor = true
	
		if walking and animator.current_animation != "Running" and animator.current_animation != "end_jump":
			animator.play("Running")
		elif !walking and animator.current_animation != "Breathing" and animator.current_animation != "end_jump":
			animator.play("Breathing")
	else:
		was_on_floor = false
	
	if translation.y < -20:
		System.game.ui.health = 0

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode >= 49 and event.scancode < 52 and has_node("Crown"):
			equipped_crown = event.scancode - 49
			for i in 3:
				$Crown.get_child(i).visible = (equipped_crown == i)

func use_crown():
	match equipped_crown:
		System.CROWN.BOOMERANG:
			if has_node("Crown"):
				$Crown.boomerang(dir)
		System.CROWN.SLOWDOWN:
			System.slow_down = !System.slow_down
		System.CROWN.TELEPORTATION:
			if has_node("Crown"):
				$Crown.throw(dir)
			else:
				crown.teleport()

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
		dead = true