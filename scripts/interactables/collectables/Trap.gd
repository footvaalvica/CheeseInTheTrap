class_name Trap extends Spammable

var active : bool = true
var _cooldown : float = 0
var _restore_counter : float = 0
var _floor : float = 0

const COOLDOWN_TIME = 5
const TIME_PER_HIT = 2
const NUMBRE_OF_FRAMES = 7

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	max_hits_counter = 12

func _process(delta):
	if _cooldown > 0:
		_cooldown = max(_cooldown - delta, 0)
	if _restore_counter == 0 :
		if current_hits_counter != 0 :
			current_hits_counter -= 1
			if current_hits_counter > 0 :
				_restore_counter = TIME_PER_HIT
	else :
		_restore_counter = max(_restore_counter - delta, 0)

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

func action() -> void : # disarm trap
	active = false
	$DisarmArea.hide()

func activate_cooldown() -> void :
	_cooldown = COOLDOWN_TIME

func on_hit_action() -> void :
	print_debug(current_hits_counter)
	_restore_counter = TIME_PER_HIT
	var frames_to_hit_ratio = max_hits_counter / NUMBRE_OF_FRAMES
	var frame : int = current_hits_counter / 2
	animated_sprite.frame = frame

func _on_area_2d_body_entered(body : Node2D):
	var jerry = body as Jerry
	if active && jerry._floor == _floor :
		$DisarmArea.visible = true
	jerry.add_trap(self)

func _on_area_2d_body_exited(body):
	$DisarmArea.hide()
	var jerry = body as Jerry
	jerry.add_trap(self)
