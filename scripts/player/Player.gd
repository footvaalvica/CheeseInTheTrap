class_name Player extends CharacterBody2D

enum Climbing_Phase {None, Entering, Exiting}

var _destroy_counter : float = 0
var _floor : int = 0 :
	get : return _floor
var _climbing_phase : Climbing_Phase = Climbing_Phase.None
var _climbing_time : float = 0
# this value should be changed to TRAPDOOR_TIME or CLIMBING_TIME upon usage
var _climbing_bound : float = 0 

const DESTROY_TIME : float = 2
const CLIMBING_TIME : float = .3
const SPEED = 300.0

var player_id : int = 1
var stairs_available : Array[Stairs]
var animated_sprite : AnimatedSprite2D

func _ready():
	animated_sprite = $AnimatedSprite2D

func _process(delta):
	stairs(delta)
	animation(delta)

func _physics_process(delta):
	if _climbing_phase != Climbing_Phase.None :
		return
	movement(delta)

func animation(delta) :
	if animated_sprite == null :
		return
	if _climbing_phase == Climbing_Phase.Entering :
		animated_sprite.animation = "climb_1"
		return
	elif _climbing_phase == Climbing_Phase.Exiting :
		animated_sprite.animation = "climb_2"
		return
	if abs(velocity.x) > 0:
		if animated_sprite.animation == "default":
			print_debug("walk")
			animated_sprite.animation = "walk"
			animated_sprite.play()
		if Input.get_action_strength("move_right_%s" % player_id) > 0 :
			animated_sprite.scale.x = abs(animated_sprite.scale.x)
		elif Input.get_action_strength("move_left_%s" % player_id) > 0 :
			animated_sprite.scale.x = - abs(animated_sprite.scale.x)
	else :
		animated_sprite.animation = "default"

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

func stairs(delta) -> void :
	if _climbing_phase == Climbing_Phase.Entering :
		stairs_enter(delta)
		return
	elif _climbing_phase == Climbing_Phase.Exiting :
		stairs_exit(delta)
		return
	if stairs_available.size() == 0 :
		return
	var stairs_chosen : Stairs = stairs_available[0]
	if Input.is_action_just_pressed("move_up_%s" % player_id):
		_climbing_bound = CLIMBING_TIME
		move_to_floor(_floor + 1)
	elif Input.is_action_just_pressed("move_down_%s" % player_id):
		_climbing_bound = CLIMBING_TIME
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
	_destroy_counter = 0

func stairs_enter(delta : float) :
	_climbing_time += delta
	print_debug(_climbing_time)
	if finished_climbing() :
		_climbing_phase = Climbing_Phase.Exiting
		_climbing_time = 0
		GameManager.instance().adjust_y_to_floor(self, _floor)
	return

func stairs_exit(delta : float) :
	_climbing_time += delta
	if finished_climbing() :
		_climbing_phase = Climbing_Phase.None
		_climbing_time = 0
		print_debug("move allowed")
	return

func finished_climbing() -> bool:
	return _climbing_time >= _climbing_bound

func move_to_floor(floor : int) :
	if floor > GameManager.instance().MAX_FLOOR or floor < 0:
		return
	if abs(floor - _floor) != 1 :
		return
	_floor = floor
	_climbing_phase = Climbing_Phase.Entering

func add_stairs(stairs : Stairs) -> void :
	stairs_available.append(stairs)

func remove_stairs(stairs : Stairs) -> void :
	stairs_available = stairs_available.filter(func (st) : return st != stairs)

func update_with_resource(player_resource : PlayerResource) -> void :
	player_id = player_resource.player_id

func get_shortcut_name() -> String :
	push_error("Using not implemented function.")
	return ""
