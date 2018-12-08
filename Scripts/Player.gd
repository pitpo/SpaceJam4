extends KinematicBody

var velocity = Vector3()
var jump_strength = 5

var equipped_crown = System.CROWN.SLOWDOWN

var x_action = 0
var z_action = 0

func _process(delta):
	if Input.is_action_just_pressed("player_crown_used"):
		System.crown_used(equipped_crown)

func _physics_process(delta):
	velocity += Vector3.DOWN * 10 * delta
	velocity.x *= 0.9
	velocity.z *= 0.9
	
	var move_x = int(Input.is_action_pressed(action_right())) - int(Input.is_action_pressed(action_left()))
	velocity.x += move_x
	var move_z = int(Input.is_action_pressed(action_backward())) - int(Input.is_action_pressed(action_forward()))
	velocity.z += move_z
	
	velocity += int(Input.is_action_pressed("player_move_jump") && is_on_floor()) * Vector3.UP * jump_strength
	
	velocity = move_and_slide(velocity, Vector3.UP)
	translation.z = clamp(translation.z, -4, 0)
	
	if translation.z < -1.3 and translation.z > -2.6:
		if move_z == 0:
			z_action = 1
		if move_x == 0:
			x_action = 1
	elif translation.z < -2.6:
		if move_z == 0:
			z_action = 2
		if move_x == 0:
			x_action = 2
	else:
		if move_z == 0:
			z_action = 0
		if move_x == 0:
			x_action = 0

func action_forward():
	match z_action:
		0:
			return "player_move_forward"
		1:
			return "player_move_left"
		2:
			return "player_move_backward"

func action_backward():
	match z_action:
		0:
			return "player_move_backward"
		1:
			return "player_move_right"
		2:
			return "player_move_forward"

func action_right():
	match x_action:
		0:
			return "player_move_right"
		1:
			return "player_move_forward"
		2:
			return "player_move_left"

func action_left():
	match x_action:
		0:
			return "player_move_left"
		1:
			return "player_move_backward"
		2:
			return "player_move_right"