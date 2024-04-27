class_name GameManager extends Node

static var _instance : GameManager
var _number_of_cheese : int = 0
var _number_of_traps : int = 3
var _clock : float = 0 : 
	get : return _clock 

func _init():
	_instance = self

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug(_instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_clock += delta

static func instance() -> GameManager :
	return _instance

# Game Logic functions ---------------------------------------------------------

func startGame() -> void :
	_clock = 0
	
func endGame() -> void :
	print_end_game_string()

func collectCheese() -> void :
	_number_of_cheese += 1

func collectTrap() -> void :
		_number_of_traps += 1
	
func catchJerry() -> void :
	# TO DO : disable Jerry movement on script
	print_debug("Jerry is caught in the trap!")

# Utility functions ------------------------------------------------------------

func print_end_game_string() -> void :
	print_debug("Game ended at " + time_pretty_string() + \
		" with " + str(_number_of_cheese) + " cheese caught")
	
func time_pretty_string() -> String :
	var time_in_ms : int = round(_clock * 60) # convert s to ms
	var min : int = time_in_ms / (60 * 60)
	var seconds : int = (time_in_ms / 60) % 60
	var ms : int = time_in_ms % 60
	return "%d:%d:%d" % [min, seconds, ms]
