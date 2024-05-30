class_name TrapPlacer extends Player

var trap_scene : PackedScene = load("res://scenes/prefabs/collectables/trap.tscn")

func _ready():
	_floor = GameManager.instance().MAX_FLOOR
	_floor_0_y = position.y + GameManager.instance().MAX_FLOOR * GameManager.instance().FLOOR_Y_DIFFERENCE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	stairs(delta)
	if Input.is_action_just_pressed("trap_action_%s" % player_id): 
		trap_action()
	if ! GameManager.instance().can_place_trap(position, _floor) :
		animated_sprite.modulate.b = 0
		animated_sprite.modulate.g = 0
	else :
		animated_sprite.modulate.b = 1
		animated_sprite.modulate.g = 1
	if ! GameManager.instance().has_more_traps() :
		animated_sprite.modulate.a = 0.4
	else :
		animated_sprite.modulate.a = 1

func _physics_process(delta):
	movement(delta)

func finished_climbing() -> bool : # Trap placer shouldn't have climb delay
	return true

func trap_action() -> void :
	if GameManager.instance().near_trap(position, _floor):
		pickup_trap()
	else :
		spawn_trap()

func spawn_trap() -> void :
	GameManager.instance().spawn_trap(trap_scene, position, _floor)

func pickup_trap() -> void :
	GameManager.instance().pick_up_trap(position, _floor)

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
