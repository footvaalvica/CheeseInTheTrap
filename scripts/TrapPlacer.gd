class_name TrapPlacer extends Player

var trap_scene : PackedScene = load("res://scenes/prefabs/collectables/trap.tscn")

func _ready():
	_floor = 6

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	stairs(delta)
	if Input.is_action_just_pressed("trap_action_%s" % player_id): 
		spawn_trap()
	if Input.is_action_just_pressed("special_%s" % player_id) :
		pickup_trap()

func _physics_process(delta):
	movement(delta)

func finished_climbing() -> bool : # Trap placer shouldn't have climb delay
	return true

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
