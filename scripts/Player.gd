class_name Player extends CharacterBody2D

var _destroy_counter : float = 0
var _floor : int = 0 :
	get : return _floor

const DESTROY_TIME : float = 3
const SPEED = 300.0

var player_id : int = 1

func _physics_process(delta):
	movement(delta)

func movement(delta) -> void:
	velocity.x = get_input_vector().x * SPEED
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)
	if collision : 
		velocity.slide(collision.get_normal())

func get_input_vector() ->  Vector2 :
	var input_vector : Vector2 = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right_%s" % player_id) \
		- Input.get_action_strength("move_left_%s" % player_id)
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

func move_to_floor(floor : int) :
	if abs(floor - _floor) != 1 :
		return
	_floor = floor
	GameManager.instance().adjust_y_to_floor(self, floor)

func update_with_resource(player_resource : PlayerResource) -> void :
	player_id = player_resource.player_id

func get_shortcut_name() -> String :
	push_error("Using not implemented function.")
	return ""
