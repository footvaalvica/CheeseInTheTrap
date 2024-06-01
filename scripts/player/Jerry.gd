class_name Jerry extends Player

enum Direction {Left, Right}

var _is_trapped : bool = false
var _is_caught : bool = false
var _direction_to_press : Direction = Direction.Left
var _stuck_counter : int = 0
var _disable_counter : float = 0
var _cheese_countdown : float = 0
var _disarm_animation_counter : float = 0
var _trap : Trap = null
var _holes : Array[Hole]
var _traps_available : Array[Trap]

const STUCKMAX : int = 10
const DISARM_ANIMATION_STEP : float = .2
const DISABLE_TIME : float = 1.5
const CHEESE_CATCH_TIME : float = 1.5

func _ready():
	super._ready()
	SPEED *= 1.05
	_floor_0_y = position.y
	_destroy_offset = -90

func _process(delta) -> void :
	super._process(delta)
	if _is_caught and _climbing_phase == Climbing_Phase.None:
		InteractionLogManager.save_jerry_death_position(position)
		queue_free()
		GameManager.instance().end_game_tom()
	if _is_trapped :
		return
	if Input.is_action_just_pressed("move_up_%s" % player_id) and (_holes.size() > 0):
		enter_hole()
	if Input.is_action_just_pressed("trap_action_%s" % player_id) : 
		disable_trap(delta)
	if Input.is_action_just_pressed("destroy_shortcut_%s" % player_id):
		destroy_blocking_object(delta)

func movement(delta) -> void :
	if _is_trapped :
		unstuck()
		return
	if _traversing:
		print_debug("traverse")
		traverse_shortcut(delta)
		return
	velocity.x = get_input_vector().x * SPEED
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)
	if collision :
		velocity.slide(collision.get_normal())

func stairs(delta) -> void :
	if (not _is_trapped) :
		super.stairs(delta)

func animation(delta) -> void :
	_disarm_animation_counter -= delta
	if (_is_trapped) :
		super.animation(delta)
		animated_sprite.animation = "stunned"
		return
	if (_disarm_animation_counter > 0) : # continue disarm animation
		return
	if (_cheese_countdown > 0):
		_cheese_countdown -= delta
		if _traversing or animated_sprite.animation == "destroy":
			return
		animated_sprite.animation = "cheese"
		animated_sprite.play()
		if Input.get_action_strength("move_right_%s" % player_id) > 0 :
			animated_sprite.scale.x = abs(animated_sprite.scale.x)
		elif Input.get_action_strength("move_left_%s" % player_id) > 0 :
			animated_sprite.scale.x = - abs(animated_sprite.scale.x)
		else:
			animated_sprite.stop()
		return
	super.animation(delta)

# Jerry unique functions ---------------------------------------------------------

func unstuck() -> void :
	var direction = get_input_vector().x
	if direction == _direction_to_press:
		_direction_to_press = switch_direction(_direction_to_press)
		_stuck_counter += 1
	if _stuck_counter >= STUCKMAX:
		_is_trapped = false
		_trap.activate_cooldown()
		_trap = null

func trap(trap : Trap) -> void :
	position.x = trap.position.x
	_is_trapped = true
	_trap = trap
	_direction_to_press = Direction.Left
	_stuck_counter = 0

func catch_cheese() -> void :
	animated_sprite.animation = "cheese" 
	animated_sprite.play()
	_cheese_countdown = CHEESE_CATCH_TIME

func caught() -> void :
	_is_caught = true

func release() -> void :
	print_debug("release")
	_is_caught = false

func enter_hole() -> void :
	queue_free()
	InteractionLogManager.save_door_used(_holes[0].name)
	GameManager.instance().end_game_jerry()
	
func disable_trap(delta : float) -> void :
	var active_traps : Array[Trap] = \
		 _traps_available.filter(func (tp) : return tp.active && tp._floor == _floor)
	if active_traps.size() == 0 :
		return
	var trap : Trap = active_traps[0]
	if GameManager.instance().in_trap_range(self, trap) :
		trap.hit()
		if animated_sprite.animation != "disarm":
			animated_sprite.animation = "disarm"
		_disarm_animation_counter = DISARM_ANIMATION_STEP
		return

# Utility functions ------------------------------------------------------------
	
func add_hole(hole : Hole) -> void :
	_holes.append(hole)

func remove_hole(hole : Hole) -> void :
	_holes = _holes.filter(func (h) : return h != hole)

func add_trap(trap : Trap) -> void :
	_traps_available.append(trap)

func remove_trap(trap : Trap) -> void :
	_traps_available = _traps_available.filter(func (tp) : return tp != trap)

func switch_direction(direction:Direction) -> Direction :
	return Direction.Right if direction == Direction.Left else Direction.Left

func get_shortcut_name() -> String :
	return "TomShortcut"
