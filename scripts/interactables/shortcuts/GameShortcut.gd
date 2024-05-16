class_name GameShortcut extends Spammable

@export var floor : int

func action():
	# TODO : trigger animation of destruction ?
	queue_free()
