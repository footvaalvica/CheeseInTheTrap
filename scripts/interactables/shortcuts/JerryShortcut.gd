class_name JerryShortcut extends GameShortcut

@onready var animated_sprite_2 : AnimatedSprite2D = $AnimatedSprite2D2

func on_hit_action() :
	var frames_to_hit_ratio = max_hits_counter / NUMBER_OF_FRAMES
	var frame : int = current_hits_counter / frames_to_hit_ratio
	if (frame != 0) :
		animated_sprite_2.show()
		animated_sprite_2.frame = frame - 1
		animated_sprite.show()
		animated_sprite.frame = frame - 1
