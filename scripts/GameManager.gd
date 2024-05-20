class_name GameManager extends Node

static var _instance : GameManager
var _number_of_cheese : int = 0
var _number_of_traps : int = 3
var _floor_0_y = 0
var _clock : float = 0 : 
	get : return _clock 
var _ready_jerry : bool = true
var _ready_tom : bool = true
var _spawning : bool = false
var _green_tick_image : Texture2D = null
var _red_cross_image : Texture2D = null

@export var tom : Tom = null
@export var jerry : Jerry = null
@export var trap_placer : TrapPlacer = null
@export var player1 : PlayerResource = null
@export var player2 : PlayerResource = null
@export var hole2 : Hole = null
@export var game_score : GameScore = null
@export var cheese_text : RichTextLabel = null
@export var trap_text : RichTextLabel = null
@export var time_text : RichTextLabel = null
@export var _jerry_ready_image : TextureRect = null
@export var _tom_ready_image : TextureRect = null
@export var _jerry_control : Control = null
@export var _tom_control : Control = null

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
	start_trap_spawning()
	game_score.winner = "Maaaaa"
	_green_tick_image = load("res://assets/green_tick.jpg")
	_red_cross_image = load("res://assets/red_cross.jpg")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (! _spawning) :
		_clock += delta
	update_texts()
	if Input.is_action_just_pressed("ready_%s" % jerry.player_id):
		_ready_jerry = not _ready_jerry
		switch_icon(_ready_jerry, _jerry_ready_image)
	if Input.is_action_just_pressed("ready_%s" % tom.player_id):
		_ready_tom = not _ready_tom
		switch_icon(_ready_tom, _tom_ready_image)
	if (_spawning and _ready_tom and _ready_jerry) :
		end_trap_spawning()

static func instance() -> GameManager :
	return _instance

# Game Logic functions ---------------------------------------------------------

func update_texts() -> void :
	cheese_text.clear()
	var cheese_string = "[center]%s[/center]" % _number_of_cheese
	cheese_text.append_text(cheese_string)
	trap_text.clear()
	var trap_string = "[center]%s[/center]" % _number_of_traps
	trap_text.append_text(trap_string)
	time_text.clear()
	var time_string = "[center]%s[center]" % time_pretty_string()
	time_text.append_text(time_string)
	

func switch_icon(ready : bool, rect : TextureRect) -> void :
	if ready :
		rect.texture = _green_tick_image
	else :
		rect.texture = _red_cross_image

func update_resource(res : PlayerResource) : 
	if res.character_name == "Tom":
		tom.update_with_resource(res)
		trap_placer.update_player_id(res.player_id)
	elif res.character_name == "Jerry":
		jerry.update_with_resource(res)
	else :
		push_error("Using resouce with unknown character name.")

func start_trap_spawning() -> void :
	tom.process_mode = Node.PROCESS_MODE_DISABLED
	jerry.process_mode = Node.PROCESS_MODE_DISABLED
	_ready_jerry = false
	_ready_tom = false
	_spawning = true

func end_trap_spawning() -> void :
	trap_placer.process_mode = Node.PROCESS_MODE_DISABLED
	trap_placer.hide()
	_tom_control.hide()
	_jerry_control.hide()
	tom.process_mode = Node.PROCESS_MODE_INHERIT
	jerry.process_mode = Node.PROCESS_MODE_INHERIT
	_spawning = false

func start_game() -> void :
	_clock = 0
	tom.process_mode = Node.PROCESS_MODE_INHERIT
	jerry.process_mode = Node.PROCESS_MODE_INHERIT
	
func end_game_jerry() -> void :
	print_end_game_string_jerry()
	game_score.cheese = _number_of_cheese
	game_score.winner = "Jerry"
	end_game()

func end_game_tom() -> void :
	print_end_game_string_tom()
	game_score.cheese = TOTAL_CHEESE - _number_of_cheese
	game_score.winner = "Tom"
	end_game()

func end_game() -> void :
	game_score.time = _clock / 60
	print_debug("switching scene")
	GameStateManager.add_cheese(game_score.cheese)
	GameStateManager.write_game_state()
	get_tree().change_scene_to_file("res://scenes/high_score_saver.tscn")

func collect_cheese() -> void :
	_number_of_cheese += 1
	jerry.catch_cheese()
	if _number_of_cheese == 2: # Enable 2nd hole when 2nd cheese caught
		hole2.visible = true
		hole2.process_mode = Node.PROCESS_MODE_INHERIT

func collect_trap() -> void :
	_number_of_traps += 1
	
func trap_jerry(trap : Trap) -> void :
	jerry.trap(trap)

func catch_jerry() -> void :
	jerry.caught()

func in_trap_range(actor : Player, trap : Trap) -> bool :
	return trap._floor == actor._floor and get_distance(actor, trap) < DISTANCE_TO_TRAP

func in_destroy_shortcut_range(actor : Player, shortcut : GameShortcut) -> bool :
	return actor._floor == shortcut.floor and get_distance(actor, shortcut) < DISTANCE_TO_SHORTCUT

func has_more_traps() -> bool :
	return _number_of_traps > 0

func can_place_trap(position : Vector2, floor : int) -> bool :
	if near_trap(position, floor) or near_stairs(position, floor) \
		or near_shortcuts(position, floor) : 
		return false
	var distance : float = abs(jerry.position.x - position.x) 
	return floor != jerry._floor or distance > DISTANCE_TO_TRAP
	
func near_trap(position : Vector2, floor : int) -> bool :
	var trap_object_list : Array [Node] = get_tree().get_nodes_in_group("Trap")
	for trap_object in trap_object_list :
		var trap : Trap = trap_object as Trap
		var distance : float = abs(trap.position.x - position.x) 
		if trap._floor == floor and distance < DISTANCE_TO_TRAP :
			return true
	return false

func near_stairs(position : Vector2, floor : int) -> bool :
	var stair_object_list : Array[Node] = get_tree().get_nodes_in_group("Stairs")
	for stairs_object in stair_object_list :
		var stairs : Stairs = stairs_object as Stairs
		var distance : float = abs(stairs.position.x - position.x) 
		if floor == stairs.floor :
			print_debug("%s has distance %f" % [stairs_object.name, distance])
		if stairs.floor == floor and distance < DISTANCE_TO_TRAP :
			return true
	return false
	
func near_shortcuts(position : Vector2, floor : int) -> bool :
	var shortcuts_object_list : Array[Node] = get_tree().get_nodes_in_group("TomShortcut") \
		+ get_tree().get_nodes_in_group("JerryShortcut")
	for shortcut_object in shortcuts_object_list :
		var shortcut : GameShortcut = shortcut_object as GameShortcut
		var distance : float = abs(shortcut.position.x - position.x)
		if shortcut.floor == floor and distance < DISTANCE_TO_TRAP :
			print_debug(shortcut.name)
			return true
	return false

func spawn_trap(trap : PackedScene, position : Vector2, floor : int) -> void :
	if _number_of_traps == 0 :
		return
	if not can_place_trap(position, floor):
		return
	var trap_instance : Node2D = trap.instantiate() as Node2D
	trap_instance.position = position
	get_parent().add_child(trap_instance)
	(trap_instance as Trap).place(floor)
	_number_of_traps -= 1

func pick_up_trap(position : Vector2, floor : int) -> void :
	var trap_object_list : Array [Node] = get_tree().get_nodes_in_group("Trap")
	var min_dist : float = INF
	var min_trap : Trap = null
	for trap_object in trap_object_list :
		var trap : Trap = trap_object as Trap
		var distance : float = abs(trap.position.x - position.x)
		print_debug("%s vs %s" % [trap._floor, floor])
		if (trap._floor == floor and distance < DISTANCE_TO_TRAP and distance < min_dist) :
			min_dist = distance
			min_trap = trap
	if (min_trap != null) :
		collect_trap()
		min_trap.collect()

func adjust_y_to_floor(player : Player, floor : int) -> void :
	print_debug("%s moving to %s" % [player.name, _floor_0_y - floor * FLOOR_Y_DIFFERENCE])
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
	var min_string : String = str(min)
	if min_string.length() == 1 :
		min_string = "0" + min_string
	var seconds_string : String = str(seconds)
	if seconds_string.length() == 1 :
		seconds_string = "0" + seconds_string
	var ms_string : String = str(ms)
	if ms_string.length() == 1 :
		ms_string = "0" + ms_string
	print_debug(seconds_string)
	return "%s:%s:%s" % [min_string, seconds_string, ms_string]

func get_distance(node1 : Node2D, node2 : Node2D) -> float : # check distance on horizontal plane
	return abs(node1.position.x - node2.position.x)
