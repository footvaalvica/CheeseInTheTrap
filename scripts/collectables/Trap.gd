class_name Trap extends Node2D

var active : bool = true
var _cooldown : float = 0
var _floor : float = 0

const COOLDOWN_TIME = 5

func _process(delta):
	if _cooldown > 0:
		_cooldown = max(_cooldown - delta, 0)

func on_collision(body : Node2D) -> void:
	var physics := body as PhysicsBody2D 
	if physics == null :
		return # ignore if not PhysicsBody2D
	var isTom : bool = physics.get_collision_layer_value(2)
	if isTom:
		if not active :
			GameManager.instance().collect_trap()
			collect()
	else :
		if active and _cooldown == 0 :
			GameManager.instance().trap_jerry(self)

func collect() -> void:
	queue_free()
	
func place(floor : int) -> void :
	_floor = floor

func activate_cooldown() -> void :
	_cooldown = COOLDOWN_TIME
