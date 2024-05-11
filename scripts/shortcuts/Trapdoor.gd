class_name Trapdoor extends Node

@export var floor : int = 0
var animated_sprite : AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite = $AnimatedSprite2D
	animated_sprite.animation_looped.connect(reset_animation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func reset_animation() :
	animated_sprite.animation = "default" 
	animated_sprite.play()

func add_trapdoor(body : Node2D) -> void :
	var tom : Tom = body as Tom
	tom.add_trapdoor(self)

func remove_trapdoor(body : Node2D) -> void :
	var tom : Tom = body as Tom
	tom.remove_trapdoor(self)

func use(tom : Tom) -> void :
	animated_sprite.animation = "opening"
	animated_sprite.play()
	if tom._floor == floor :
		tom.move_to_floor(floor - 1)
	else:
		tom.move_to_floor(floor)
		
