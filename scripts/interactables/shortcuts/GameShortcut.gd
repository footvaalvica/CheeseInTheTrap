class_name GameShortcut extends Spammable

@export var floor : int
@export var distance : float

func action():
	# TODO : trigger animation of destruction ?
	queue_free()
