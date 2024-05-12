class_name Tom extends Player

var trap_scene : PackedScene = load("res://scenes/prefabs/collectables/trap.tscn")
var trapdoors_available : Array[Trapdoor] = []

const TRAPDOOR_TIME : float = .15

func _ready():
	super._ready()
	_floor = 6

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if Input.is_action_just_pressed("trap_action_%s" % player_id) :
		spawn_trap()
	if Input.get_action_raw_strength("destroy_shortcut_%s" % player_id) > 0 :
		destroy_blocking_object(delta)
	if Input.is_action_just_pressed("special_%s" % player_id) :
		pickup_trap()
	if Input.is_action_just_pressed("special2nd_%s" % player_id) :
		use_trapdoor()

func on_collision(body : Node2D) -> void :
	var physics := body as PhysicsBody2D 
	print_debug("catch")
	if physics == null :
		return # ignore if not PhysicsBody2D
	var isJerry : bool = physics.get_collision_layer_value(3)
	if isJerry:
		GameManager.instance().catch_jerry()

func spawn_trap() -> void :
	GameManager.instance().spawn_trap(trap_scene, position, _floor)

func pickup_trap() -> void :
	GameManager.instance().pick_up_trap(position, _floor)
	
func add_trapdoor(trapdoor : Trapdoor) -> void :
	trapdoors_available.append(trapdoor)
	
func remove_trapdoor(trapdoor : Trapdoor) -> void :
	trapdoors_available = trapdoors_available.filter(func(tpd) : return tpd != trapdoor)

func use_trapdoor() -> void:
	if trapdoors_available.size() == 0 :
		return
	var trapdoor : Trapdoor = trapdoors_available[0]
	_climbing_time = TRAPDOOR_TIME
	trapdoor.use(self)

func get_shortcut_name() -> String :
	return "JerryShortcut"

