class_name HighScoreManager extends Node

@export var text_edit : TextEdit
@export var game_score : GameScore
@export var leaderboard_canvas_layer : CanvasLayer
@export var canvas_layer : CanvasLayer
@export var leaderboard_button: Button
@export var leaderboard: LeaderboardUI
@export var score_label: Label
@export var go_to_menu_button: Button
@export var save_score_button: Button
var cheese : int
var time : float
var score : int

func _ready():
	cheese = game_score.cheese
	time = game_score.time
	score = (cheese * 3 - time) * 20
	score = 100000
	score_label.text = "Score:" + str(score)
	
func add_score(name : String, cheese : int, time : float) :
	var success: bool = await Leaderboards.post_guest_score("cheeseinthetrap-highscore-wHeL", score, name)

func _on_leaderboards_pressed():
	await leaderboard.refresh_scores()
	leaderboard_canvas_layer.show()
	canvas_layer.hide()

func _on_save_score_pressed():
	var name = text_edit.text
	add_score(name, cheese, time)
	save_score_button.hide()
	leaderboard_button.show()
	go_to_menu_button.show()

func _on_go_to_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_button_pressed():
	leaderboard_canvas_layer.hide()
	canvas_layer.show()
