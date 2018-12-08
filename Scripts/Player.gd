extends KinematicBody

var velocity = Vector3()
var jump_strength = 5

func _physics_process(delta):
	velocity += Vector3.DOWN * 10 * delta
	velocity.x *= 0.9
	velocity.z *= 0.9
	
	velocity.x += int(Input.is_action_pressed("player_move_right")) - int(Input.is_action_pressed("player_move_left"))
	velocity.z += int(Input.is_action_pressed("player_move_backward")) - int(Input.is_action_pressed("player_move_forward"))
	
	velocity += int(Input.is_action_pressed("player_move_jump") && is_on_floor()) * Vector3.UP * jump_strength
	
	velocity = move_and_slide(velocity, Vector3.UP)
	translation.z = clamp(translation.z, -4, 0)