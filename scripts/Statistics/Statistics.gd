class_name Statistics extends Node2D

var statistics_entries : Array[StatisticsEntry]
const DIR_PATH = "user://game_logs/"
const LOG_FORMAT = "user://game_logs/%s"

func _ready() :
	read_logs()

func read_logs():
	var dir = DirAccess.open(DIR_PATH)
	var files : PackedStringArray = dir.get_files()
	for file_name in files :
		if file_name.contains("100"):
			return
		var file = FileAccess.open(LOG_FORMAT % file_name, FileAccess.READ)
		var entry = parse_entry(file)

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
	print_debug(entry)
	return entry
	
func vector2_from_str(vec_str: String) :
	var coords : PackedStringArray = vec_str.rstrip(")").lstrip("(").split(", ")
	return  Vector2(float(coords[0]), float(coords[1]))
