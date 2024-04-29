class_name GameManager extends Node

static var _instance : GameManager
var _number_of_cheese : int = 0
var _number_of_traps : int = 3
var _clock : float = 0 : 
	get : return _clock 
	
@export var tom : Tom = null
@export var jerry : Jerry = null

const TOTAL_CHEESE = 3
const DISTANCE_TO_TRAP = 100 # FIXME : should this vary between tom and jerry ?

func _init():
	_instance = self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_clock += delta

static func instance() -> GameManager :
	return _instance

# Game Logic functions ---------------------------------------------------------

func start_game() -> void :
	_clock = 0
	
func end_game_jerry() -> void :
	print_end_game_string_jerry()

func end_game_tom() -> void :
	print_end_game_string_tom()

func collect_cheese() -> void :
	_number_of_cheese += 1

func collect_trap() -> void :
	_number_of_traps += 1
	
func trap_jerry(trap : Trap) -> void :
	jerry.trap(trap)
	
func catch_jerry() -> void :
	jerry.caught()
	
func in_trap_range(actor : Player, trap : Node2D) -> bool :
	var distance : float = actor.position.x - trap.position.x # FIXME : need to improve this to work with floors
	return distance < DISTANCE_TO_TRAP

func can_place_trap(position : Vector2) -> bool :
	var trap_object_list : Array [Node] = get_tree().get_nodes_in_group("Trap")
	for trap_object in trap_object_list :
		var trap_object_2d : Node2D = trap_object as Node2D
		var distance : float = abs(trap_object_2d.position.x - position.x) # FIXME Check if in same level 
		if distance < DISTANCE_TO_TRAP :
			return false
	return true

func spawn_trap(trap : PackedScene, position : Vector2) -> void :
	if _number_of_traps == 0 :
		return
	if not can_place_trap(position):
		return
	var trap_instance : Node2D = trap.instantiate() as Node2D
	trap_instance.position = position
	get_parent().add_child(trap_instance)
	_number_of_traps -= 1

# Utility functions ------------------------------------------------------------

func print_end_game_string_jerry() -> void :
	print_debug("Jerry escaped in " + time_pretty_string() + \
		" with " + str(_number_of_cheese) + " cheese caught")
		
func print_end_game_string_tom() -> void :
	print_debug("Tom caught Jerry in " + time_pretty_string() + \
		" with " + str(TOTAL_CHEESE - _number_of_cheese) + " cheese left")
	
func time_pretty_string() -> String :
	var time_in_ms : int = round(_clock * 60) # convert s to ms
	var min : int = time_in_ms / (60 * 60)
	var seconds : int = (time_in_ms / 60) % 60
	var ms : int = time_in_ms % 60
	return "%d:%d:%d" % [min, seconds, ms]
