class_name MainGameMenu extends Control

@export var options: CanvasLayer
@export var start : Button
@export var rest_of_menu: CanvasLayer

func _ready():
	start.grab_focus()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/character_selection.tscn")

func _on_options_pressed():
	options.show()
	rest_of_menu.hide()

func _on_goback_pressed():
	options.hide()
	rest_of_menu.show()


func _on_button_pressed():
	get_tree().quit()
