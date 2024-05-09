extends Node

@export var player_1 : PlayerResource
@export var player_2 : PlayerResource

func tom_jerry() -> void :
	update_resources_and_load_game("Tom", "Jerry")

func jerry_tom() -> void :
	update_resources_and_load_game("Jerry", "Tom")

func update_resources_and_load_game(player1 : String, player2 : String) -> void :
	player_1.character_name = player1
	player_2.character_name = player2
	print_debug("%s plays as %s" % [player_1.player_id, player_1.character_name])
	print_debug("%s plays as %s" % [player_2.player_id, player_2.character_name])
	get_tree().change_scene_to_file("res://scenes/map_test.tscn")
