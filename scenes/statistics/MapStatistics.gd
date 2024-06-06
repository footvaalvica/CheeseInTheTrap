class_name MapStatistics extends Node
	
@export var death_heat : PackedScene
@export var trap_heat : PackedScene
var entry : StatisticsEntry
	
func apply_death_heat():
	for death :  Vector2 in entry.death_positions :
		var instance : Node2D = death_heat.instantiate() as Node2D
		instance.position = death
		get_parent().add_child(instance)

func apply_trap_heat():
	for trap : Vector2 in entry.trap_positions :
		var instance : Node2D = trap_heat.instantiate() as Node2D
		instance.position = trap
		get_parent().add_child(instance)
