class_name GameShortcut extends Node2D

@export var floor : int

func destroy():
	# TODO : trigger animation of destruction ?
	queue_free()
