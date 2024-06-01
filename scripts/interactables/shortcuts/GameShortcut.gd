class_name GameShortcut extends Spammable

@export var floor : int
@export var distance : float
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

@export var breaking_sound : AudioStreamPlayer

const NUMBER_OF_FRAMES = 3

func _ready():
	max_hits_counter = 12

func action():
	breaking_sound.play()
	animated_sprite.hide()
	#  remove object from map
	self.position = Vector2(1000000, 1000000)
	
func on_hit_action():
	var frames_to_hit_ratio = max_hits_counter / NUMBER_OF_FRAMES
	var frame : int = current_hits_counter / frames_to_hit_ratio
	animated_sprite.frame = frame

func enter_traverse_area(body : Node2D) :
	print_debug(body.name)
	var jerry = body as Jerry
	if (jerry != null) :
		jerry.start_traverse_shortcut()
	var tom = body as Tom
	if (tom != null) :
		tom.start_traverse_shortcut()

func exit_traverse_area(body : Node2D):
	print_debug(body.name)
	var jerry = body as Jerry
	if (jerry != null) :
		jerry.stop_traverse_shortcut()
	var tom = body as Tom
	if (tom != null) :
		tom.stop_traverse_shortcut()
