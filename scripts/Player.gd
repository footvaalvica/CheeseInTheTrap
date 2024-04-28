class_name Player extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta):
	movement(delta)

func movement(delta) -> void:
	velocity.x = get_input_vector().x * SPEED
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)
	if collision : 
		velocity.slide(collision.get_normal())

func get_input_vector() ->  Vector2 :
	var input_vector : Vector2 = Vector2.ZERO
	var ext : String = get_action_name_extension()
	input_vector.x = Input.get_action_strength("move_right_" + ext) - Input.get_action_strength("move_left_" + ext)
	return input_vector.normalized() if input_vector.length() > 1 else input_vector
	
func get_action_name_extension() -> String :
	push_error("Using not implemented function.")
	return ""
