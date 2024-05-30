class_name Utils

static func time_pretty_string(raw : float) -> String : 
	var time_in_ms : int = round(raw * 60) # convert raw s to ms
	var min : int = time_in_ms / (60 * 60)
	var seconds : int = (time_in_ms / 60) % 60
	var ms : int = time_in_ms % 60
	var min_string : String = str(min)
	if min_string.length() == 1 :
		min_string = "0" + min_string
	var seconds_string : String = str(seconds)
	if seconds_string.length() == 1 :
		seconds_string = "0" + seconds_string
	var ms_string : String = str(ms)
	if ms_string.length() == 1 :
		ms_string = "0" + ms_string
	return "%s:%s:%s" % [min_string, seconds_string, ms_string]
