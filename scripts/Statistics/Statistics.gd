class_name Statistics extends Node2D

var statistics_entries : Array[StatisticsEntry]
const DIR_PATH = "user://game_logs/"
const LOG_FORMAT = "user://game_logs/%s"

func _ready() :
	read_logs()

func read_logs():
	statistics_entries = [StatisticsEntry.new(3), StatisticsEntry.new(5), StatisticsEntry.new(5)]
	var dir = DirAccess.open(DIR_PATH)
	var files : PackedStringArray = dir.get_files()
	for file_name in files :
		var log_number = int(file_name.substr("log".length()))
		if log_number > 100 :
			continue
		print_debug("processing : %s" % file_name)
		var file = FileAccess.open(LOG_FORMAT % file_name, FileAccess.READ)
		var entry = parse_entry(file)
		var map_rank = 0
		if entry["winner"] == "tom":
			map_rank = entry["score"] + entry["cheese_caught"].size()
		else :
			map_rank = guess_jerry_rank(entry)
		if map_rank == 3 :
			process_entry(entry, 0)
		elif map_rank == 5 :
			process_entry(entry, 1)
			process_entry(entry, 2)
		else :
			print_debug("INVALID MAP RANK : %d" % map_rank)
			get_tree().quit()
			return
	print_debug("%d entries" % statistics_entries.size())
	for entry in statistics_entries:
		entry.print_entry()
	var packed : PackedScene = load("res://scenes/statistics/map_1_statistics.tscn")
	var instance : Node2D = packed.instantiate() as Node2D
	var map_stats : MapStatistics = instance.get_node("MapStatistics") as MapStatistics
	map_stats.entry = statistics_entries[0]
	map_stats.apply_death_heat()
	get_parent().add_child.call_deferred(instance)
	get_parent().get_child_count()
	

func parse_entry(file : FileAccess):
	var entry : Dictionary
	file.get_line() # remove first line
	var line = file.get_line()
	if line.contains("death"):
		var vector_string : String = line.split(" : ")[1].strip_edges().rstrip(",")
		entry["death_position"] = vector2_from_str(vector_string)
		line = file.get_line()
	if line.contains("trap_pos"):
		line = file.get_line()
		var pos : Array[Vector2]
		while not line.contains("]") :
			if line.strip_edges() == ",":
				line = file.get_line()
				continue
			var vector_string: String = line.strip_edges()
			pos.append(vector2_from_str(vector_string))
			line = file.get_line()
		entry["trap_positions"] = pos
		line = file.get_line()
	if line.contains("cheese") :
		line = file.get_line()
		var cheese : Array[String]
		while not line.contains("]") :
			if line.strip_edges() == ",":
				line = file.get_line()
				continue
			cheese.append(line.strip_edges().rstrip("\"").lstrip("\""))
			line = file.get_line()
		entry["cheese_caught"] = cheese
		line = file.get_line()
	if line.contains("door") :
		var door_name = line.split(" : ")[1].strip_edges().rstrip(",").rstrip("\"").lstrip("\"")
		entry["door_used"] = door_name
		line = file.get_line()
	var score_str = line.split(" : ")[1].strip_edges().rstrip(",")
	entry["score"] = int(score_str)
	line = file.get_line()
	var winner = line.split(" : ")[1].strip_edges().lstrip("\"").rstrip("\"")
	entry["winner"] = winner
	#print_debug(entry)
	return entry

func process_entry(entry : Dictionary, index : int) :
	var stats_entry = statistics_entries[index]
	for cheese : String in entry["cheese_caught"]:
		var num : int
		if cheese.split("Cheese")[1] != "" :
			num = int(cheese.split("Cheese")[1])
		else :
			num = 1
		stats_entry.cheese_percentages[num - 1] += 1
		stats_entry.cheese_total += 1
	for trap : Vector2 in entry["trap_positions"] :
		stats_entry.trap_positions.append(trap)
	if entry["winner"] == "tom" :
		stats_entry.death_positions.append(entry["death_position"])
		stats_entry.tom_score += entry["score"]
		stats_entry.total_wins += 1
	else:
		var door_index : int
		if entry["door_used"] == "Hole":
			door_index = 0
		else :
			if entry["door_used"].split("OptionalDoor")[1] != "":
				door_index = int(entry["door_used"].split("OptionalDoor")[1])
			else :
				door_index = 1
		stats_entry.doors_percentages[door_index] += 1
		stats_entry.door_total += 1
		stats_entry.jerry_score += entry["score"]
		print_debug("jerry score : %s" % entry["score"])
		stats_entry.jerry_wins += 1
		stats_entry.total_wins += 1


func guess_jerry_rank(entry : Dictionary) -> int :
	if entry["score"] > 3:
		return 5
	for cheese : String in entry["cheese_caught"]:
		if cheese.contains("4") or cheese.contains("5") :
			return 5
	if entry["door_used"].contains("4"):
		return 5
	return 3

func vector2_from_str(vec_str: String) :
	var coords : PackedStringArray = vec_str.rstrip(")").lstrip("(").split(", ")
	return  Vector2(float(coords[0]), float(coords[1]))
