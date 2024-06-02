class_name GameManager extends Node

static var _instance : GameManager
var _number_of_cheese : int = 0
var _number_of_traps : int = 0
var _clock : float = 0 : 
	get : return _clock 
var _ready_jerry : bool = true
var _ready_tom : bool = true
var _spawning : bool = false
var _second_door : bool = false
var _safety_set : bool = false
var _green_tick_image : Texture2D = null
var _red_cross_image : Texture2D = null
var start_counter : float = 0

@export var MAX_FLOOR = 6 # XXX : this should be a comstant
@export var TOTAL_CHEESE = 3
@export var MAX_TRAPS = 3

@export var _title : String
@export var tom : Tom = null
@export var jerry : Jerry = null
@export var trap_placer : TrapPlacer = null
@export var safety_zone : SafetyArea = null
@export var player1 : PlayerResource = null
@export var player2 : PlayerResource = null
@export var second_holes : Array[Hole]
@export var game_score : GameScore = null
@export var cheese_text : RichTextLabel = null
@export var trap_text : RichTextLabel = null
@export var time_text : RichTextLabel = null
@export var hint_text : RichTextLabel = null
@export var start_text : RichTextLabel = null
@export var _jerry_ready_image : TextureRect = null
@export var _tom_ready_image : TextureRect = null
@export var _jerry_control : Control = null
@export var _tom_control : Control = null	

@export var preparation_song : AudioStreamPlayer
@export var main_music : AudioStreamPlayer
@export var catch_cheese : AudioStreamPlayer
@export var pickup_trap : AudioStreamPlayer
@export var drop_trap : AudioStreamPlayer
@export var jerry_caught_in_trap : AudioStreamPlayer
@export var jerry_ready : AudioStreamPlayer
@export var tom_ready : AudioStreamPlayer
@export var both_ready : AudioStreamPlayer

const DISTANCE_TO_TRAP = 70
const DISTANCE_TO_SAFETY = 80
const DISTANCE_TO_STAIRS = 45
const DISTANCE_TO_CHEESE = 45
const DISTANCE_TO_SHORTCUT = 150
const FLOOR_Y_DIFFERENCE = 91.44
const START_TEXT_TIME = 1

func _init():
	_instance = self
	print_debug(_number_of_traps)

# Called when the node enters the scene tree for the first time.
func _ready():
	MenuMusic.stop()
	print_debug(_title)
	_number_of_traps = MAX_TRAPS
	update_resource(player1)
	update_resource(player2)
	for hole2 in second_holes :
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
	update_texts(delta)
	if Input.is_action_just_pressed("ready_%s" % jerry.player_id):
		_ready_jerry = not _ready_jerry
		switch_icon(_ready_jerry, _jerry_ready_image)
		if _ready_jerry:
			jerry_ready.play()
	if Input.is_action_just_pressed("ready_%s" % tom.player_id):
		_ready_tom = not _ready_tom
		switch_icon(_ready_tom, _tom_ready_image)
		if _ready_tom:
			tom_ready.play()
	if (_spawning and _ready_tom and _ready_jerry) :
		both_ready.play()
		end_trap_spawning()

static func instance() -> GameManager :
	return _instance

# Game Logic functions ---------------------------------------------------------

func update_texts(delta : float) -> void :
	cheese_text.clear()
	var cheese_string = "[center][color=orange]%s[/color][/center]" % _number_of_cheese
	cheese_text.append_text(cheese_string)
	trap_text.clear()
	var trap_string = "[center][color=orange]%s[/color][/center]" % _number_of_traps
	trap_text.append_text(trap_string)
	time_text.clear()
	var time_string = "[center][color=orange]%s[/color][/center]" % Utils.time_pretty_string(_clock)
	time_text.append_text(time_string)
	if (start_counter > 0):
		start_counter = max(start_counter - delta, 0)
	else :
		start_text.hide()

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
		safety_zone.update_player_id(res.player_id)
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
	safety_zone.process_mode = Node.PROCESS_MODE_DISABLED
	safety_zone.hide()
	hint_text.hide()
	start_text.visible = true
	start_counter = START_TEXT_TIME
	_tom_control.hide()
	_jerry_control.hide()
	tom.process_mode = Node.PROCESS_MODE_INHERIT
	jerry.process_mode = Node.PROCESS_MODE_INHERIT
	_spawning = false
	preparation_song.stop()
	main_music.play()

func start_game() -> void :
	_clock = 0
	tom.process_mode = Node.PROCESS_MODE_INHERIT
	jerry.process_mode = Node.PROCESS_MODE_INHERIT
	
func end_game_jerry() -> void :
	print_end_game_string_jerry()
	InteractionLogManager.save_jerry_win(_number_of_cheese)
	game_score.cheese = _number_of_cheese
	game_score.winner = "Jerry"
	end_game()

func end_game_tom() -> void :
	print_end_game_string_tom()
	game_score.cheese = TOTAL_CHEESE - _number_of_cheese
	InteractionLogManager.save_tom_win(TOTAL_CHEESE - _number_of_cheese)
	game_score.winner = "Tom"
	end_game()

func end_game() -> void :
	game_score.time = _clock / 60
	game_score.max_cheese = TOTAL_CHEESE
	game_score.map_name = _title
	print_debug("switching scene")
	InteractionLogManager.save_log()
	GameStateManager.add_cheese(game_score.cheese)
	GameStateManager.write_game_state()
	get_tree().change_scene_to_file("res://scenes/high_score_saver.tscn")

func collect_cheese() -> void :
	catch_cheese.play()
	_number_of_cheese += 1
	jerry.catch_cheese()
	if _number_of_cheese > TOTAL_CHEESE * 0.6 and ! _second_door: # Enable 2nd hole after 60% of the cheese caught
		var ind = randi_range(0, second_holes.size() - 1)
		var hole2 = second_holes[ind]
		hole2.visible = true
		hole2.process_mode = Node.PROCESS_MODE_INHERIT
		_second_door = true

func collect_trap(trap : Trap) -> void :
	_number_of_traps += 1
	jerry.remove_trap(trap)
	pickup_trap.play()
	
func trap_jerry(trap : Trap) -> void :
	jerry.trap(trap)
	jerry_caught_in_trap.play()

func catch_jerry() -> void :
	jerry.caught()
	
func release_jerry() -> void :
	jerry.release()

func in_trap_range(actor : Player, trap : Trap) -> bool :
	return trap._floor == actor._floor and get_distance(actor, trap) < DISTANCE_TO_TRAP

func in_destroy_shortcut_range(actor : Player, shortcut : GameShortcut) -> bool :
	return actor._floor == shortcut.floor and get_distance(actor, shortcut) < DISTANCE_TO_SHORTCUT

func has_more_traps() -> bool :
	return _number_of_traps > 0

func can_place_trap(position : Vector2, floor : int) -> bool :
	if near_trap(position, floor) or near_stairs(position, floor) \
		or near_shortcuts(position, floor) or near_cheese(position, floor) \
		or near_safety_zone(position, floor) : 
		return false
	var distance : float = abs(jerry.position.x - position.x) 
	return floor != jerry._floor or distance > DISTANCE_TO_TRAP

func can_place_safety_zone(position : Vector2, floor : int) -> bool :
	return !near_stairs(position, floor) and !near_shortcuts(position, floor)

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
		if stairs.floor == floor and distance < DISTANCE_TO_STAIRS :
			return true
	return false
	
func near_shortcuts(position : Vector2, floor : int) -> bool :
	var shortcuts_object_list : Array[Node] = get_tree().get_nodes_in_group("TomShortcut") \
		+ get_tree().get_nodes_in_group("JerryShortcut")
	for shortcut_object in shortcuts_object_list :
		var shortcut : GameShortcut = shortcut_object as GameShortcut
		var distance : float = abs(shortcut.position.x - position.x)
		if shortcut.floor == floor and distance < shortcut.distance :
			return true
	return false

func near_cheese(position : Vector2, floor : int) -> bool :
	var cheese_object_list : Array[Node] = get_tree().get_nodes_in_group("Cheese")
	for cheese_object in cheese_object_list :
		var cheese : Cheese = cheese_object as Cheese
		var distance : float = abs(cheese.position.x - position.x)
		if cheese.floor == floor and distance < DISTANCE_TO_CHEESE :
			return true
	return false

func near_safety_zone(position : Vector2, floor : int) -> bool :
	return _spawning and _safety_set and safety_zone._floor == floor \
		and abs(safety_zone.position.x - position.x) < DISTANCE_TO_SAFETY

func spawn_trap(trap : PackedScene, position : Vector2, floor : int) -> void :
	if _number_of_traps == 0 :
		return
	if not can_place_trap(position, floor):
		return
		
	
	var trap_instance : Node2D = trap.instantiate() as Node2D
	trap_instance.position = position
	trap_instance.position.y = (jerry._floor_0_y - FLOOR_Y_DIFFERENCE * floor) + FLOOR_Y_DIFFERENCE * 1/8
	get_parent().add_child(trap_instance)
	(trap_instance as Trap).place(floor)
	_number_of_traps -= 1
	InteractionLogManager.save_trap_set_position(position)
	drop_trap.play()

func pick_up_trap(position : Vector2, floor : int) -> void :
	var trap_object_list : Array [Node] = get_tree().get_nodes_in_group("Trap")
	var min_dist : float = INF
	var min_trap : Trap = null
	for trap_object in trap_object_list :
		var trap : Trap = trap_object as Trap
		var distance : float = abs(trap.position.x - position.x)
		if (trap._floor == floor and distance < DISTANCE_TO_TRAP and distance < min_dist) :
			min_dist = distance
			min_trap = trap
	if (min_trap != null) :
		collect_trap(min_trap)
		min_trap.collect()
	

func set_safety_zone(position : Vector2, floor : int) -> void :
	var trap_object_list : Array [Node] = get_tree().get_nodes_in_group("Trap")
	for trap_object in trap_object_list :
		var trap : Trap = trap_object as Trap
		var distance : float = abs(trap.position.x - position.x)
		if (trap._floor == floor and distance < DISTANCE_TO_SAFETY) :
			collect_trap(trap)
			trap.collect()
	_safety_set = true

func adjust_y_to_floor(player : Player, floor : int) -> void :
	print_debug("%s moving to %s" % [player.name, player._floor_0_y - floor * FLOOR_Y_DIFFERENCE])
	print_debug("previous y : %s" % player.position.y)
	player.position.y = player._floor_0_y - floor * FLOOR_Y_DIFFERENCE
	print_debug("current y : %s" % player.position.y)

# Utility functions ------------------------------------------------------------

func print_end_game_string_jerry() -> void :
	print_debug("Jerry escaped in " + Utils.time_pretty_string(_clock) + \
		" with " + str(_number_of_cheese) + " cheese caught")
		
func print_end_game_string_tom() -> void :
	print_debug("Tom caught Jerry in " + Utils.time_pretty_string(_clock) + \
		" with " + str(TOTAL_CHEESE - _number_of_cheese) + " cheese left")

func get_distance(node1 : Node2D, node2 : Node2D) -> float : # check distance on horizontal plane
	return abs(node1.position.x - node2.position.x)
