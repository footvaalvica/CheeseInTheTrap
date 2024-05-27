class_name MapSelection extends Node

@export var cheese_label : RichTextLabel = null
@export var start_focus : Control 
@export var start_button : Button
var current_map_resource : MapResource
var total_cheese : int = 0
static var instance : MapSelection

func _init():
	instance = self
	GameStateManager.read_game_state()
	total_cheese = GameStateManager.cheese

func _ready():
	start_focus.grab_focus()
	cheese_label.text = "[center]%s[/center]" % total_cheese

func start() -> void :
	if (current_map_resource != null) :
		#get_tree().change_scene_to_packed(current_map_resource.map_scene)
		get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
		GameStateManager.map = current_map_resource.map_scene

func back() -> void :
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func switch_map(new_map : MapResource) -> void :
	print_debug("switc")
	current_map_resource = new_map
	start_button.grab_focus()

