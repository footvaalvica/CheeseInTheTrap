class_name TutorialManager extends Node

@export var player1 : PlayerResource
@export var player2 : PlayerResource
@export var vid : VideoStreamPlayer
@export var switch_button : Button
@export var start_button : Button
var vid_stream_keyboard : VideoStreamTheora
var vid_stream_gamepad : VideoStreamTheora

func _ready():
	start_button.grab_focus()
	vid_stream_keyboard = VideoStreamTheora.new() 
	vid_stream_gamepad = VideoStreamTheora.new()
	load_video_streams()
	vid.stream = vid_stream_gamepad
	vid.play()
	

func _switch():
	if vid.stream == vid_stream_keyboard:
		vid.stream = vid_stream_gamepad
		switch_button.text = "Keyboard"
	else :
		vid.stream = vid_stream_keyboard
		switch_button.text = "Gamepad"
	vid.play()

func load_video_streams():
	if player1.character_name == "Jerry":
		vid_stream_keyboard.file = "res://assets/videostutorial/jerrytomkeyboard.ogv"
		vid_stream_gamepad.file = "res://assets/videostutorial/jerrytompad.ogv"
	else :
		vid_stream_keyboard.file = "res://assets/videostutorial/tomjerrykeyboard.ogv"
		vid_stream_gamepad.file = "res://assets/videostutorial/tomjerrypad.ogv"


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/rules.tscn")
