class_name HighScoreManager extends Node

@export var text_edit : TextEdit
@export var game_score : GameScore
@export var leaderboard_canvas_layer : CanvasLayer
@export var canvas_layer : CanvasLayer
@export var leaderboard_button: Button
@export var leaderboard : Leaderboard
@export var score_label: Label
@export var go_to_menu_button: Button
@export var save_score_button: Button
@export var go_back_button : Button
@export var star_5: Sprite2D
@export var star_4: Sprite2D
@export var star_3: Sprite2D
@export var star_2: Sprite2D
@export var star_1: Sprite2D
@export var winner_text: RichTextLabel
@export var jerry_wins : AudioStreamPlayer
@export var tom_wins : AudioStreamPlayer

var high_score_map : Dictionary
const MAX_TABLE = 20
const FILE_PATH = "user://highscores.dat"

var cheese : int
var max_cheese : int
var time : float
var score : int
var winner : String
var map_name : String

func _ready():
	cheese = game_score.cheese
	max_cheese = game_score.max_cheese
	save_score_button.grab_focus()
	time = game_score.time
	winner = game_score.winner
	map_name = game_score.map_name
	score_label.text = "Time:" + str(Utils.time_pretty_string(time))
	winner_text.text = "[rainbow][center]Winner: " + winner
	load_highscores()
	
	if (max_cheese == 5): # have 5 stars
		star_4.get_parent().show()
		star_5.get_parent().show()
		var tmp = star_1
		star_1 = star_4
		star_4 = tmp
		tmp = star_2
		star_2 = star_4
		star_4 = tmp
		tmp = star_3
		star_3 = star_4
		star_4 = tmp
	
	if winner == "Jerry":
		jerry_wins.play()
	else:
		tom_wins.play()
	
	if cheese > 0:
		star_1.show()
	if cheese > 1:
		star_2.show()
	if cheese > 2:
		star_3.show()
	if cheese > 3:
		star_4.show()
	if cheese > 4:
		star_5.show()
		
	if (game_score.map_name == "" || ! is_new_score()) :
		next_buttons_show()

func _exit_tree():
	save_highscores()

func add_score(name : String) :
	var entry : HighScoreEntry = HighScoreEntry.new(name, cheese, time)
	var title = "%s - %s" % [map_name, winner]
	var high_score_table = high_score_map.get(title)
	if high_score_table == null :
		high_score_table = []
	var length : int = min(high_score_table.size() + 1, MAX_TABLE)
	var i : int = 0
	var propagate : bool = false
	if high_score_table.size() < length :
		high_score_table.resize(length)
	while i < length:
		if high_score_table[i] == null or entry.compare_to(high_score_table[i]) \
			> 0 or propagate :
			var tmp = high_score_table[i]
			high_score_table[i] = entry
			entry = tmp
			propagate = true
		i += 1
	high_score_map[title] = high_score_table
	save_highscores()

func is_new_score() :
	var high_score_table = high_score_map.get(map_name)
	if high_score_table == null || high_score_table.size() < 10:
		return true
	var length = MAX_TABLE
	return high_score_table[length - 1].compare_to_values(cheese, time) < 0

func load_highscores() : 
	if not FileAccess.file_exists(FILE_PATH) :
		var new_file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
		new_file.store_string("{\n}")
		new_file.close()
		return
	var highscore_file = FileAccess.open(FILE_PATH, FileAccess.READ)
	highscore_file.get_line() # first line is {
	var line = highscore_file.get_line()
	while line != "}" :
		var title = line.split(" :")[0].rstrip("\"").lstrip("\"")
		var high_score_table = []
		line = highscore_file.get_line().rstrip(",").strip_edges()
		while line != "]" and line != "],":
			var content : Dictionary = JSON.parse_string(line)
			var entry = HighScoreEntry.new(content["name"], content["cheese"], content["time"])
			high_score_table.append(entry)
			line = highscore_file.get_line().rstrip(",").strip_edges()
		high_score_map[title] = high_score_table
		line = highscore_file.get_line().strip_edges()
	highscore_file.close()

func save_highscores() :
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_line("{")
	for i in range(high_score_map.keys().size()) :
		var map_name = high_score_map.keys()[i]
		var high_score_table = high_score_map[map_name]
		file.store_line("\"%s\" : [" % map_name)
		for j in high_score_table.size() :
			var entry = high_score_table[j]
			file.store_string(JSON.stringify(entry.to_dictionary()))
			if j < high_score_table.size() - 1 :
				file.store_string(",")
			file.store_string("\n")
		if (i < high_score_map.keys().size() - 1) :
			file.store_line("\t],")
		else :
			file.store_line("\t]")
	file.store_line("}")
	file.close()

func _on_leaderboards_pressed():
	leaderboard_canvas_layer.show()
	leaderboard.scores = high_score_map
	leaderboard.map_index = 0
	leaderboard.refresh()
	go_back_button.grab_focus()
	canvas_layer.hide()

func _on_save_score_pressed():
	var name = text_edit.text
	add_score(name)
	next_buttons_show()

func next_buttons_show() :
	text_edit.placeholder_text = ""
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
