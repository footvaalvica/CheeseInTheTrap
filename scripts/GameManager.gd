class_name GameManager extends Node

static var _instance : GameManager
var _number_of_cheese : int = 0
var _number_of_traps : int = 3
var _clock : float = 0 : 
	get : return _clock 
	
@export var tom : Tom = null
@export var jerry : Jerry = null

const TOTAL_CHEESE = 3

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
