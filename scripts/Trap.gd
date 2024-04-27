class_name Trap extends Node

var active : bool = true

func on_collision(body : Node2D) -> void:
	var physics := body as PhysicsBody2D 
	if physics == null :
		return # ignore if not PhysicsBody2D
	var isTom : bool = physics.get_collision_layer_value(2)
	if isTom:
		if not active :
			GameManager.instance().collectTrap()
			collect()
	else :
		GameManager.instance().catchJerry()

func collect() -> void:
	queue_free()
