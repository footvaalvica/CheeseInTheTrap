class_name Spammable extends Node2D

var max_hits_counter : int = 10
var current_hits_counter : int = 0

func hit():
	current_hits_counter += 1
	on_hit_action()
	if (current_hits_counter == max_hits_counter) :
		action()
	
# called when max reached
func action():
	pass # override in children classes

# called after every hit
func on_hit_action():
	pass # override in children classes
