class_name	Cheese extends Node2D

func on_collision(body : Node2D) -> void:
	GameManager.instance().collect_cheese()
	queue_free()
