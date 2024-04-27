class_name Player extends CharacterBody2D

@export var player_id = 0
const SPEED = 300.0

func _physics_process(delta):
	movement()

func movement() -> void:
	velocity.x = get_input_vector().x * SPEED
	move_and_slide()
	
func get_input_vector() ->  Vector2 :
	var input_vector : Vector2 = Vector2.ZERO
	var ext : String = get_action_name_extension()
	input_vector.x = Input.get_action_strength("move_right_" + ext) - Input.get_action_strength("move_left_" + ext)
	return input_vector.normalized() if input_vector.length() > 1 else input_vector
	
func get_action_name_extension() -> String :
	if player_id == 0 :
		return "tom"
	else :
		return "jerry"
	
