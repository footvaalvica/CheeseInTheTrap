class_name TutorialManager extends Node

@export var player1 : PlayerResource
@export var player2 : PlayerResource
@export var vid : VideoStreamPlayer
@export var switch_button : Button
var vid_stream_keyboard : VideoStreamTheora
var vid_stream_gamepad : VideoStreamTheora

func _ready():
	vid_stream_keyboard = VideoStreamTheora.new() 
	vid_stream_gamepad = VideoStreamTheora.new()
	load_video_streams()
	vid.stream = vid_stream_keyboard
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
		vid_stream_keyboard.file = "res://assets/videos/jerry1tom2keyboard.ogv"
		vid_stream_gamepad.file = "res://assets/videos/jerry1tom2gamepad.ogv"
	else :
		vid_stream_keyboard.file = "res://assets/videos/tom1jerry2keyboard.ogv"
		vid_stream_gamepad.file = "res://assets/videos/tom1jerry2gamepad.ogv"


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/map_test.tscn")
