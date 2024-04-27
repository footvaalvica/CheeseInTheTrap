class_name	Cheese extends Node2D

func on_collision(body : Node2D) -> void:
	print_debug("cheese caught")
	GameManager.instance().collectCheese()
	queue_free()
