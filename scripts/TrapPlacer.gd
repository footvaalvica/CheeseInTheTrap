class_name TrapPlacer extends Player

var trap_scene : PackedScene = load("res://scenes/prefabs/collectables/trap.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if Input.is_action_just_pressed("trap_action_%s" % player_id): 
		spawn_trap()

func spawn_trap() -> void :
	GameManager.instance().spawn_trap(trap_scene, position)

func update_player_id(id : int):
	player_id = id
