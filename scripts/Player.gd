class_name Player extends CharacterBody2D

var _destroy_counter : float = 0

const DESTROY_TIME : float = 3
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

func destroy_blocking_object(delta : float) -> void :
	var in_range_blocking_object : Shortcut = null
	var blocking_object_list : Array [Node] = get_tree().get_nodes_in_group(get_shortcut_name())
	for blocking_object in blocking_object_list :
		var shortcut_script : GameShortcut = blocking_object as GameShortcut
		if GameManager.instance().in_destroy_shortcut_range(self, blocking_object) :
			_destroy_counter += delta
			if _destroy_counter >= DESTROY_TIME :
				shortcut_script.destroy()
				return
		else :
			_destroy_counter = 0

func get_action_name_extension() -> String :
	push_error("Using not implemented function.")
	return ""

func get_shortcut_name() -> String :
	push_error("Using not implemented function.")
	return ""
