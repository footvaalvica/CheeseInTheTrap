class_name HighScoreManager extends Node

var high_score_table : Array[HighScoreEntry]
const MAX_TABLE = 10
const FILE_PATH = "res://highscores.dat"

@export var text_edit : TextEdit
@export var cheese : int
@export var time : float

func _ready():
	load_highscores()

func _exit_tree():
	save_highscores()

func load_highscores() : 
	if not FileAccess.file_exists(FILE_PATH) :
		var new_file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
		new_file.store_string("[\n]")
		new_file.close()
		return
	var highscore_file = FileAccess.open(FILE_PATH, FileAccess.READ)
	highscore_file.get_line() # first line is [
	var line = highscore_file.get_line()
	while line != "]" :
		var content : Dictionary = JSON.parse_string(line)
		var entry = HighScoreEntry.new(content["name"], content["cheese"], content["time"])
		high_score_table.append(entry)
		line = highscore_file.get_line()
	highscore_file.close()

func save_highscores() :
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_line("[")
	for entry in high_score_table :
		file.store_line(JSON.stringify(entry.to_dictionary()))
	file.store_line("]")
	file.close()

func add_score(name : String, cheese : int, time : float) :
	var entry : HighScoreEntry = HighScoreEntry.new(name, cheese, time)
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

func is_new_score(cheese : int, time : float) :
	var length = min(high_score_table.size() + 1, MAX_TABLE)
	return high_score_table[length].compare_to_values(cheese, time)

func button_pressed():
	var name = text_edit.text
	add_score(name, cheese, time)
