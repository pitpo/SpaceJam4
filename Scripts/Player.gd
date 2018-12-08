extends KinematicBody

onready var crown_origin = $Crown.translation
onready var animator = $PlayerModel/AnimationPlayer

var velocity = Vector3()
var jump_strength = 8
var dir = 1

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
	velocity += Vector3.DOWN * 30 * delta
	velocity.x *= 0.9
	velocity.z *= 0.9
	
	var move_x = int(Input.is_action_pressed("player_move_right")) - int(Input.is_action_pressed("player_move_left"))
	velocity.x += move_x
	var move_z = int(Input.is_action_pressed("player_move_backward")) - int(Input.is_action_pressed("player_move_forward"))
	velocity.z += move_z
	
	if move_x > 0:
		$PlayerModel.rotation_degrees.y = 90
		dir = 1
	elif move_x < 0:
		$PlayerModel.rotation_degrees.y = -90
		dir = -1
	
	if Input.is_action_pressed("player_move_jump") and is_on_floor():
		velocity += Vector3.UP * jump_strength
		animator.play("start_jump")
	
	velocity = move_and_slide(velocity, Vector3.UP, true, 4, deg2rad(20))
	translation.z = clamp(translation.z, -4, 0)
	
	if is_on_floor():
		if !was_on_floor:
			animator.play("end_jump")
		was_on_floor = true
	else:
		was_on_floor = false

func use_crown():
	match equipped_crown:
		System.CROWN.BOOMERANG:
			if has_node("Crown"):
				$Crown.boomerang(dir)
		System.CROWN.SLOWDOWN:
			System.emit_signal("slowdown_switched")

func animation_end(anim):
	if anim == "start_jump":
		animator.play("true_mid Jump")
	elif anim == "end_jump":
		animator.play("Breathing")