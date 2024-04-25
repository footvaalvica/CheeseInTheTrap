class_name	Cheese extends Node2D

func on_collision(body : Node2D):
	GameManager.instance().collectCheese()
	queue_free()
