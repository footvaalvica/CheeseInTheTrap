class_name Leaderboard extends Control

@onready var score_list : Tree = %ScoreList
var scores : Dictionary
var map_names : Array[String]
var map_index : int = -1

func _ready():
	score_list.set_column_expand_ratio(1, 3)
	var column_names := ["Name", "Stars", "Time"]
	for i in range(column_names.size()) :
		var column_name : String = column_names[i]
		score_list.set_column_title(i, column_name)
		score_list.set_column_title_alignment(i, HORIZONTAL_ALIGNMENT_LEFT)
	if map_index == -1 :
		map_index = 0
	if (scores != null):
		refresh()

func refresh() -> void :
	score_list.clear()
	var root = score_list.create_item()
	var scores_in_map = scores[map_names[map_index]]
	for score in scores_in_map :
		var score_entry : TreeItem = score_list.create_item(root)
		score_entry.set_text(0, score._name)
		score_entry.set_text(1, str(score._cheese))
		score_entry.set_text(2, str(score._time))

func _on_prev_button_pressed():
	map_index = (map_index - 1) % map_names.size()

func _on_next_button_pressed():
	map_index = (map_index + 1) % map_names.size()
