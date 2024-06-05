class_name MapStatistics extends Node
	
@export var heat : PackedScene
var entry : StatisticsEntry
	
func apply_death_heat():
	print_debug("death : %d" % entry.death_positions.size())
	for death :  Vector2 in entry.death_positions :
		var instance : Node2D = heat.instantiate() as Node2D
		instance.position = death
		get_parent().add_child(instance)
