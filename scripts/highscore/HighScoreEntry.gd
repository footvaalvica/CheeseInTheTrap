class_name HighScoreEntry

var _name : String
var _cheese : int
var _time : float

func _init(name : String, cheese : int, time : float) :
	_name = name
	_cheese = cheese
	_time = time

func compare_to(other : HighScoreEntry) :
	return compare_to_values(other._cheese, other._time)
		
func compare_to_values(cheese : int, time : float) :
	if _cheese == cheese :
		return time - _time # less time is better
	else :
		return _cheese - cheese

func to_dictionary() -> Dictionary :
	return {"name" : _name, "cheese" : _cheese, "time" : _time}
