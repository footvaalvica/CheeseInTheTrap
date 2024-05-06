class_name GameManager extends Node

static var _instance : GameManager
var _number_of_cheese : int = 0
var _number_of_traps : int = 3
var _floor_0_y = 0
var _clock : float = 0 : 
	get : return _clock 
	
@export var tom : Tom = null
@export var jerry : Jerry = null
@export var player1 : PlayerResource = null
@export var player2 : PlayerResource = null
@export var hole2 : Hole = null

const TOTAL_CHEESE = 3
const DISTANCE_TO_TRAP = 100 # FIXME : should this vary between tom and jerry ?
const DISTANCE_TO_SHORTCUT = 150
const MAX_FLOOR = 6
const FLOOR_Y_DIFFERENCE = 91.43

func _init():
	_instance = self

# Called when the node enters the scene tree for the first time.
func _ready():
	_floor_0_y = jerry.position.y
	update_resource(player1)
	update_resource(player2)
	hole2.hide()
	hole2.process_mode = Node.PROCESS_MODE_DISABLED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_clock += delta

static func instance() -> GameManager :
	return _instance

# Game Logic functions ---------------------------------------------------------

func update_resource(res : PlayerResource) : 
	if res.character_name == "Tom":
		tom.update_with_resource(res)
	elif res.character_name == "Jerry":
		jerry.update_with_resource(res)
	else :
		push_error("Using resouce with unknown character name.")

func start_game() -> void :
	_clock = 0
	
func end_game_jerry() -> void :
	print_end_game_string_jerry()

func end_game_tom() -> void :
	print_end_game_string_tom()

func collect_cheese() -> void :
	_number_of_cheese += 1
	if _number_of_cheese == 2: # Enable 2nd hole when 2nd cheese caught
		hole2.visible = true
		hole2.process_mode = Node.PROCESS_MODE_INHERIT

func collect_trap() -> void :
	_number_of_traps += 1
	
func trap_jerry(trap : Trap) -> void :
	jerry.trap(trap)

func catch_jerry() -> void :
	jerry.caught()

func in_trap_range(actor : Player, trap : Node2D) -> bool :  #FIXME : need to improve this to work with floors
	return get_distance(actor, trap) < DISTANCE_TO_TRAP

func in_destroy_shortcut_range(actor : Player, shortcut : Node2D) -> bool :
	return get_distance(actor, shortcut) < DISTANCE_TO_SHORTCUT

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

func adjust_y_to_floor(player : Player, floor : int) -> void : # FIXME : update this to work with actual floors 
	print_debug("%s moving to $s" % [player.name, _floor_0_y - floor * FLOOR_Y_DIFFERENCE])
	player.position.y = _floor_0_y - floor * FLOOR_Y_DIFFERENCE

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
	
func get_distance(node1 : Node2D, node2 : Node2D) -> float : # check distance on horizontal plane
	return abs(node1.position.x - node2.position.x)
