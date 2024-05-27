class_name GameStateManager

static var cheese : int = 0
static var map : PackedScene = null
const FILE_PATH : String = "res://game_state.dat"

static func read_game_state() :
	if not FileAccess.file_exists(FILE_PATH) :
		var new_file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
		new_file.store_string("{\n\"cheese\" : 0\n}")
		new_file.close()
		return
	var game_state = FileAccess.open(FILE_PATH, FileAccess.READ)
	game_state.get_line() # first line is {
	var cheese_line = game_state.get_line()
	cheese = int(cheese_line.split("\"cheese\" : ")[1])
	game_state.close()

static func write_game_state() -> void :
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_line("{")
	file.store_line("\"cheese\" : %d" % cheese)
	file.store_line("}")
	file.close()

static func add_cheese(cheese_obtained : int) -> void :
	cheese += cheese_obtained
