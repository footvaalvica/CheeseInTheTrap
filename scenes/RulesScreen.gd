class_name RulesScreen extends Control

func _ready():
	$MarginContainer/VBoxContainer/play.grab_focus()

func pressed():
	get_tree().change_scene_to_packed(GameStateManager.map)
