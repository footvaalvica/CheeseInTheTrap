class_name Jerry extends Player

enum Direction {Left, Right}

var _is_trapped : bool = false
var _direction_to_press : Direction = Direction.Left
var _stuck_counter : int = 0
var _disable_counter : float = 0
var _trap : Trap = null
var _holes : Array[Hole]

const STUCKMAX : int = 10
const DISABLE_TIME : float = 1.5

func _process(delta):
	super._process(delta)
	if Input.is_action_just_pressed("special_%s" % player_id) and (_holes.size() > 0):
		enter_hole()
	if Input.get_action_strength("trap_action_%s" % player_id) > 0 : 
		disable_trap(delta)
	else :
		_disable_counter = 0
	if Input.get_action_strength("destroy_shortcut_%s" % player_id) > 0 :
		destroy_blocking_object(delta)
	else:
		_destroy_counter = 0

func movement(delta) -> void :
	if _is_trapped :
		unstuck()
		return
	velocity.x = get_input_vector().x * SPEED
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)
	if collision :
		velocity.slide(collision.get_normal())

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
	_is_trapped = true
	_trap = trap
	_direction_to_press = Direction.Left
	_stuck_counter = 0

func caught() -> void :
	queue_free()
	GameManager.instance().end_game_tom()
	
func enter_hole() -> void :
	queue_free()
	GameManager.instance().end_game_jerry()
	
func disable_trap(delta : float) -> void :
	var trap_object_list : Array [Node] = get_tree().get_nodes_in_group("Trap")
	for trap_object in trap_object_list :
		var trap_script : Trap = trap_object as Trap
		if not trap_script.active :
			continue
		if GameManager.instance().in_trap_range(self, trap_object) :
			_disable_counter += delta
			if _disable_counter >= DISABLE_TIME :
				trap_script.active = false
				print_debug("disarm")
			return
	_disable_counter = 0

# Utility functions ------------------------------------------------------------
	
func add_hole(hole : Hole) -> void :
	_holes.append(hole)
	
func remove_hole(hole : Hole) -> void :
	_holes = _holes.filter(func (h) : return h != hole)
	
func switch_direction(direction:Direction) -> Direction :
	return Direction.Right if direction == Direction.Left else Direction.Left

func get_shortcut_name() -> String :
	return "TomShortcut"
