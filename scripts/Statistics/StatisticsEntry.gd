class_name StatisticsEntry

var jerry_wins : int = 0
var total_wins : int = 0

var death_positions : Array[Vector2]

var trap_positions : Array[Vector2]

var cheese_percentages : Array[float]
var cheese_total : int = 0

var doors_percentages : Array[float]
var door_total : int = 0

var jerry_score : int = 0
var tom_score : int = 0

func _init(size : int):
	for i in range(size):
		cheese_percentages.append(0)
	if size == 3 :
		doors_percentages = [0, 0, 0, 0]
	else :
		doors_percentages = [0, 0, 0, 0, 0]

func print_entry():
	for i in range(cheese_percentages.size()) :
		cheese_percentages[i] /= cheese_total
	for i in range(doors_percentages.size()) :
		doors_percentages[i] /= door_total
	var jerry_percentage = float(jerry_wins) / total_wins
	var tom_wins = total_wins - jerry_wins
	print("---------------------------------")
	print("cheese_percentages : %s" % str(cheese_percentages))
	print("door_percentages : %s" % str(doors_percentages))
	print("jerry winning percentage : %f" % jerry_percentage)
	print("jerry average score : %f" % (float(jerry_score) / jerry_wins))
	print("tom winning percentage : %f" % (1 - jerry_percentage))
	print("tom average score : %f" % (float(tom_score) / tom_wins))
	print("---------------------------------")
