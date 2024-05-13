class_name Stairs extends Node2D

@export var floor : int = 0

func add_stairs(body : Node2D) -> void :
	var player = body as Player
	player.add_stairs(self)

func remove_stairs(body : Node2D) -> void :
	var player = body as Player
	player.remove_stairs(self)
