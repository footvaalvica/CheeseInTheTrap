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
@export var go_back_button : Button
@export var star_3: Sprite2D
@export var star_2: Sprite2D
@export var star_1: Sprite2D
@export var winner_text: RichTextLabel

var cheese : int
var time : float
var score : int
var winner : String

func _ready():
	cheese = game_score.cheese
	save_score_button.grab_focus()
	time = game_score.time
	winner = game_score.winner
	score = (cheese * 3 - time) * 20
	score = 100000
	score_label.text = "Score:" + str(score)
	winner_text.text = "[rainbow][center]Winner: " + winner
	
	# todo fix this
	var cheese_to_star = cheese
	if cheese_to_star > 0:
		star_1.show()
	if cheese_to_star > 1:
		star_2.show()
	if cheese_to_star > 2:
		star_3.show()
	
func add_score(name : String, cheese : int, time : float) :
	var score: int = (cheese * 3 - time) * 20
	var success: bool = await Leaderboards.post_guest_score("cheeseinthetrap-highscore-wHeL", score, name)
	print_debug(success)

func _on_leaderboards_pressed():
	await leaderboard.refresh_scores()
	leaderboard_canvas_layer.show()
	go_back_button.grab_focus()
	canvas_layer.hide()

func _on_save_score_pressed():
	var name = text_edit.text
	add_score(name, cheese, time)
	save_score_button.hide()
	leaderboard_button.show()
	leaderboard_button.grab_focus()
	go_to_menu_button.show()

func _on_button_pressed():
	leaderboard_canvas_layer.hide()
	canvas_layer.show()
	leaderboard_button.grab_focus()

func _on_go_to_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
