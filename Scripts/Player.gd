extends KinematicBody

var velocity = Vector3()
var jump_strength = 7

var equipped_crown = System.CROWN.SLOWDOWN

func _ready():
	$PlayerModel/AnimationPlayer.get_animation("default").loop = true
	$PlayerModel/AnimationPlayer.play("default")

func _process(delta):
	if Input.is_action_just_pressed("player_crown_used"):
		System.crown_used(equipped_crown)

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
	
	velocity = move_and_slide(velocity, Vector3.UP, true)
	translation.z = clamp(translation.z, -4, 0)