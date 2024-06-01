class_name InteractionLogManager

static var tom_positions : Array[Vector2]
static var jerry_positions : Array[Vector2]
static var death_position : Vector2
static var trap_positions : Array[Vector2]
static var cheese_caught : Array[String]
static var door_used : String
static var score : int
static var winner : String

static var file_counter : int = 0

const LOG_FOLDER = "user://game_logs"
const LOG_FORMAT = "user://game_logs/log%d.log"

static func save_log() :
	if file_counter <= 0 :
		load_file_counter()
	var log_file = FileAccess.open(LOG_FORMAT % file_counter, FileAccess.WRITE)
	log_file.store_line("{")
	if (death_position != Vector2.ZERO) : 
		log_file.store_line("\"death_position\" : " + str(death_position) + ",")
	log_file.store_line("\"trap_positions\" : [")
	for i in range(trap_positions.size()):
		var pos = trap_positions[i]
		log_file.store_line(str(pos))
		if (i < trap_positions.size() - 1):
			log_file.store_line(",")
	log_file.store_line("],")
	log_file.store_line("\"cheese_caught\" : [")
	for i in range(cheese_caught.size()):
		var cheese = cheese_caught[i]
		log_file.store_line("\"" + cheese + "\"")
		if (i < cheese_caught.size() - 1):
			log_file.store_line(",")
	log_file.store_line("],")
	if (door_used != "") :
		log_file.store_line("\"door_used\" : \"" + door_used + "\",")
	log_file.store_line("\"score\" : " + str(score) + ",")
	log_file.store_line("\"winner\" : \"" + winner + "\"")
	log_file.store_line("}")
	log_file.close()
	file_counter += 1

static func save_tom_position(position : Vector2) :
	tom_positions.append(position)

static func save_jerry_position(position : Vector2) :
	jerry_positions.append(position)

static func save_jerry_death_position(position : Vector2) :
	death_position = position

static func save_trap_set_position(position : Vector2) :
	trap_positions.append(position)

static func save_cheese_caught(cheese : String) :
	cheese_caught.append(cheese)

static func save_door_used(door : String) :
	door_used = door

static func save_tom_win(game_score : int) :
	winner = "tom"
	score = game_score

static func save_jerry_win(game_score : int) :
	winner = "jerry"
	score = game_score

static func load_file_counter() :
	file_counter = 1
	if (! DirAccess.dir_exists_absolute(LOG_FOLDER)) :
		DirAccess.make_dir_absolute(LOG_FOLDER)
		return
	while true :
		if (! FileAccess.file_exists(LOG_FORMAT % file_counter)) :
			return
		file_counter += 1
