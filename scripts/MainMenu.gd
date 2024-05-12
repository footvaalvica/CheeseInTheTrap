class_name MainMenu extends Control

@export var options: CanvasLayer
@export var rest_of_menu: CanvasLayer

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/character_selection.tscn")

func _on_quit_pressed():
	get_tree().quit() 

func _on_options_pressed():
	options.show()
	rest_of_menu.hide()

func _on_goback_pressed():
	options.hide()
	rest_of_menu.show()
