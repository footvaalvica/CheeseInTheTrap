class_name Trapdoor extends Node

@export var floor : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_trapdoor(body : Node2D) -> void :
	var tom : Tom = body as Tom
	tom.add_trapdoor(self)

func remove_trapdoor(body : Node2D) -> void :
	var tom : Tom = body as Tom
	tom.remove_trapdoor(self)

func use(tom : Tom) -> void :
	if tom._floor == floor :
		tom.move_to_floor(floor - 1)
	else:
		tom.move_to_floor(floor)
		
