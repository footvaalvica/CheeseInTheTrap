class_name SafetyArea extends Player

var sprite : Sprite2D
var area_set : bool = false

@export var audio : AudioStreamPlayer

func _ready():
	_floor_0_y = position.y
	sprite = $Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if area_set :
		return
	stairs(delta)
	if ! GameManager.instance().can_place_safety_zone(position, _floor) :
		sprite.modulate.b = 0
		sprite.modulate.g = 0
		return
	else :
		sprite.modulate.b = 1
		sprite.modulate.g = 1
	if Input.is_action_just_pressed("trap_action_%s" % player_id): 
		trap_action()

func _physics_process(delta):
	if area_set :
		return
	movement(delta)

func finished_climbing() -> bool : # Safety Area shouldn't have climb delay
	return true

func trap_action() -> void :
	sprite.modulate.a = 1
	audio.play()
	audio.finished.connect(func () : process_mode = Node.PROCESS_MODE_DISABLED)
	GameManager.instance().set_safety_zone(position, _floor)
	area_set = true

func stairs(delta) -> void :
	if _climbing_phase == Climbing_Phase.Entering :
		stairs_enter(delta)
		return
	elif _climbing_phase == Climbing_Phase.Exiting :
		stairs_exit(delta)
		return
	if Input.is_action_just_pressed("move_up_%s" % player_id):
		move_to_floor(_floor + 1)
	elif Input.is_action_just_pressed("move_down_%s" % player_id):
		move_to_floor(_floor - 1)

func update_player_id(id : int):
	player_id = id
