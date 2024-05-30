class_name MainGameMenu extends Control

@export var options: CanvasLayer
@export var start : Button
@export var rest_of_menu: CanvasLayer

func _ready():
	start.grab_focus()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") && options.visible :
		_on_go_back_pressed()
		start.grab_focus()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/character_selection.tscn")

func _on_quit_pressed():
	get_tree().quit() 

func _on_options_pressed():
	options.show()
	rest_of_menu.hide()

func _on_go_back_pressed():
	options.hide()
