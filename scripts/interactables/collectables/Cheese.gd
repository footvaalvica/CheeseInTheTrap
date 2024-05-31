class_name	Cheese extends Node2D

@export var floor : int

func on_collision(body : Node2D) -> void:
	GameManager.instance().collect_cheese()
	InteractionLogManager.save_cheese_caught(name)
	queue_free()
