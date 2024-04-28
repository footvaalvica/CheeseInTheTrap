class_name Jerry extends Player

enum Direction {Left, Right}

var _is_trapped : bool = false
var _direction_to_press : Direction = Direction.Left
var _stuck_counter : int = 0
var _trap : Trap = null

const STUCKMAX : int = 10

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
	queue_free() # TODO : do things when Jerry is caught ?
	
# Utility functions ------------------------------------------------------------
	
func switch_direction(direction:Direction) -> Direction :
	return Direction.Right if direction == Direction.Left else Direction.Left

func get_action_name_extension() -> String :
	return "jerry"
