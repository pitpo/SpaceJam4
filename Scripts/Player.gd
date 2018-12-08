extends KinematicBody

var velocity = Vector3()
var jump_strength = 8

var equipped_crown = System.CROWN.BOOMERANG

onready var crown_origin = $Crown.translation

func _init():
	System.player = self

func _ready():
	$PlayerModel/AnimationPlayer.get_animation("default").loop = true
	$PlayerModel/AnimationPlayer.play("default")

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
	
	if Input.is_action_pressed("player_move_jump") and is_on_floor():
		velocity += Vector3.UP * jump_strength
	
	velocity = move_and_slide(velocity, Vector3.UP, true, 4, deg2rad(20))
	translation.z = clamp(translation.z, -4, 0)

func use_crown():
	match equipped_crown:
		System.CROWN.BOOMERANG:
			if has_node("Crown"):
				$Crown.boomerang()
		System.CROWN.SLOWDOWN:
			System.emit_signal("slowdown_switched")