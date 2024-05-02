class_name Tom extends Player

var trap_scene : PackedScene = load("res://scenes/prefabs/trap.tscn")
var trapdoors_available : Array[Trapdoor] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("place_trap"): 
		spawn_trap()
	if Input.get_action_raw_strength("destroy_shortcut_tom") > 0 :
		destroy_blocking_object(delta)
	if Input.is_action_just_pressed("use_trapdoor") :
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
	GameManager.instance().spawn_trap(trap_scene, position)
	
func add_trapdoor(trapdoor : Trapdoor) -> void :
	trapdoors_available.append(trapdoor)
	
func remove_trapdoor(trapdoor : Trapdoor) -> void :
	trapdoors_available = trapdoors_available.filter(func(tpd) : return tpd != trapdoor)

func use_trapdoor() -> void:
	if trapdoors_available.size() == 0 :
		return
	var trapdoor : Trapdoor = trapdoors_available[0]
	trapdoor.use(self)

func get_action_name_extension() -> String :
	return "tom"

func get_shortcut_name() -> String :
	return "JerryShortcut"

