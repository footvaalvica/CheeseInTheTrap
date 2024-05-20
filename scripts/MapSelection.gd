class_name MapSelection extends Node

@export var total_cheese : int = 0
@export var cheese_label : RichTextLabel = null
var current_map_resource : MapResource
static var instance : MapSelection

func _init():
	instance = self

func _ready():
	cheese_label.text = "[center]%s[/center]" % total_cheese

func start() -> void :
	get_tree().change_scene_to_packed(current_map_resource.map_scene)

func back() -> void :
	get_tree().change_scene_to_file("res://scenes/character_selection.tscn")

func switch_map(new_map : MapResource) -> void :
	current_map_resource = new_map
