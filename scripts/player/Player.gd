class_name Player extends CharacterBody2D

enum Climbing_Phase {None, Entering, Exiting}

var _floor : int = 0 :
	get : return _floor
var _floor_0_y = 0
var _climbing_phase : Climbing_Phase = Climbing_Phase.None
var _climbing_time : float = 0
# this value should be changed to TRAPDOOR_TIME or CLIMBING_TIME upon usage
var _climbing_bound : float = 0 

var _destroy_offset : float = 0

const CLIMBING_TIME : float = .15
var SPEED = 300.0

var player_id : int = 1
var stairs_available : Array[Stairs]
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var _traversing : bool = false 

@export var shortcut : AudioStreamPlayer 
@export var hammer_sound : AudioStreamPlayer

func _ready():
	animated_sprite.animation_looped.connect(animation_finished)

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
	if _traversing :
		return
	if animated_sprite.animation == "destroy" :
		return
	if _climbing_phase == Climbing_Phase.Entering :
		animated_sprite.animation = "climb_1"
		return
	elif _climbing_phase == Climbing_Phase.Exiting :
		animated_sprite.animation = "climb_2"
		return
	if abs(velocity.x) > 0:
		if animated_sprite.animation != "walk" :
			print_debug("walk")
			animated_sprite.animation = "walk"
			animated_sprite.play()
		if Input.get_action_strength("move_right_%s" % player_id) > 0 :
			animated_sprite.scale.x = abs(animated_sprite.scale.x)
		elif Input.get_action_strength("move_left_%s" % player_id) > 0 :
			animated_sprite.scale.x = - abs(animated_sprite.scale.x)
	else :
		animated_sprite.animation = "default"
		
func animation_finished() -> void :
	if animated_sprite.animation != "destroy" :
		return
	animated_sprite.animation = "default"
	animated_sprite.offset.y = 0

func movement(delta) -> void:
	if _traversing:
		print_debug("traverse")
		traverse_shortcut(delta)
		return
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
	if ! get_tree(): # Godot still signals events after scene was changed
		return
	var blocking_object_list : Array [Node] = get_tree().get_nodes_in_group(get_shortcut_name())
	for blocking_object in blocking_object_list :
		var shortcut_script : GameShortcut = blocking_object as GameShortcut
		if GameManager.instance().in_destroy_shortcut_range(self, blocking_object) \
			&& turned_to(shortcut_script.position):
			shortcut_script.hit()
			hammer_sound.play()
			animated_sprite.play("destroy")
			animated_sprite.offset.y = _destroy_offset
			return

func turned_to(pos : Vector2):
	var diff : int = sign(pos.x - position.x)
	print_debug("diff %d" %diff)
	var scale_dir : int = sign(animated_sprite.scale.x)
	print_debug("scale %s" % scale_dir)
	return diff == scale_dir

func stairs_enter(delta : float) :
	_climbing_time += delta
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

func progress_frame() -> void :
	animated_sprite.frame += 1

func regress_frame() -> void :
	animated_sprite.frame -= 1

func start_traverse_shortcut() -> void :
	animated_sprite.animation = "shortcut"
	animated_sprite.play()
	_traversing = true
	shortcut.play()
	print_debug("traversing")

func stop_traverse_shortcut() -> void :
	_traversing = false
	print_debug("traverse over")

func traverse_shortcut(delta : float) -> void :
	var side = sign(animated_sprite.scale.x)
	velocity.x = side * SPEED
	print_debug(velocity.x)
	move_and_collide(velocity * delta)

func update_with_resource(player_resource : PlayerResource) -> void :
	player_id = player_resource.player_id

func get_shortcut_name() -> String :
	push_error("Using not implemented function.")
	return ""
