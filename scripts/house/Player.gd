class_name Player extends CharacterBody2D

var _destroy_counter : float = 0
var _floor : int = 0 :
	get : return _floor

const DESTROY_TIME : float = 3
const SPEED = 300.0

var player_id : int = 1
var stairs_available : Array[Stairs]

func _process(delta):
	stairs()

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

func stairs() -> void :
	if stairs_available.size() == 0 :
		return
	var stairs_chosen : Stairs = stairs_available[0]
	if Input.is_action_just_pressed("move_up_%s" % player_id):
		move_to_floor(_floor + 1)
	elif Input.is_action_just_pressed("move_down_%s" % player_id):
		move_to_floor(_floor - 1)

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
	if floor > GameManager.instance().MAX_FLOOR or floor < 0:
		return
	print_debug("move to floor")
	if abs(floor - _floor) != 1 :
		return
	_floor = floor
	print_debug("adjusting floor")
	GameManager.instance().adjust_y_to_floor(self, floor)

func add_stairs(stairs : Stairs) -> void :
	stairs_available.append(stairs)

func remove_stairs(stairs : Stairs) -> void :
	stairs_available = stairs_available.filter(func (st) : return st != stairs)

func update_with_resource(player_resource : PlayerResource) -> void :
	player_id = player_resource.player_id

func get_shortcut_name() -> String :
	push_error("Using not implemented function.")
	return ""