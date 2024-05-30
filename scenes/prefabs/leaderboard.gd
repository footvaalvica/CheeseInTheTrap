class_name Leaderboard extends Control

@onready var score_list : Tree = %ScoreList
@onready var title_label : Label = %Map

var scores : Dictionary
var map_index : int = -1

func _ready():
	score_list.set_column_expand_ratio(1, 2)
	var column_names := ["Rank", "Name", "Stars", "Time"]
	score_list.columns = column_names.size()
	for i in range(column_names.size()) :
		var column_name : String = column_names[i]
		score_list.set_column_title(i, column_name)
		score_list.set_column_title_alignment(i, HORIZONTAL_ALIGNMENT_LEFT)
	if map_index == -1 :
		map_index = 0
	if (! scores.is_empty()):
		print_debug(scores)
		refresh()

func refresh() -> void :
	score_list.clear()
	var map_name = scores.keys()[map_index]
	title_label.text = map_name
	var root = score_list.create_item()
	var scores_in_map = scores[map_name]
	for i in range(scores_in_map.size()) :
		var score = scores_in_map[i]
		var score_entry : TreeItem = score_list.create_item(root)
		score_entry.set_text(0, str(i+1))
		score_entry.set_text(1, score._name)
		score_entry.set_text(2, str(score._cheese))
		score_entry.set_text(3, str(Utils.time_pretty_string(score._time)))

func _on_prev_button_pressed():
	map_index = (map_index - 1) % scores.keys().size()
	print_debug(-1 % 3)
	refresh()

func _on_next_button_pressed():
	map_index = (map_index + 1) % scores.keys().size()
	refresh()

