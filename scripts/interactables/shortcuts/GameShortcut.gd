class_name GameShortcut extends Spammable

@export var floor : int
@export var distance : float

func action():
	# TODO : trigger animation of destruction ?
	queue_free()

func enter_traverse_area(body : Node2D) :
	print_debug(body.name)
	var jerry = body as Jerry
	if (jerry != null) :
		jerry.start_traverse_shortcut()
	var tom = body as Tom
	if (tom != null) :
		tom.start_traverse_shortcut()

func exit_traverse_area(body : Node2D):
	print_debug(body.name)
	var jerry = body as Jerry
	if (jerry != null) :
		jerry.stop_traverse_shortcut()
	var tom = body as Tom
	if (tom != null) :
		tom.stop_traverse_shortcut()
