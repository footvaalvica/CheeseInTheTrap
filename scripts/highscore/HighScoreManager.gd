class_name HighScoreManager extends Node

@export var text_edit : TextEdit
@export var game_score : GameScore
@export var leaderboard : LeaderboardUI
@export var canvas_layer : CanvasLayer
var cheese : int
var time : float

func _ready():
	cheese = game_score.cheese
	time = game_score.time
	
func add_score(name : String, cheese : int, time : float) :
	var score: int = (cheese * 3 - time) * 20
	var success: bool = await Leaderboards.post_guest_score("cheeseinthetrap-highscore-wHeL", score, name)
	
func button_pressed():
	var name = text_edit.text
	add_score(name, cheese, time)

	await leaderboard.refresh_scores()
	leaderboard.show()
	canvas_layer.hide()
