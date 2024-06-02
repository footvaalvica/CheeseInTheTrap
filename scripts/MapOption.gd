class_name MapOption extends  Control

@export var resource : MapResource = null
@export var locked_image : CompressedTexture2D
@export var locked_image_focused : CompressedTexture2D

var title : RichTextLabel
var image : TextureRect
var button : TextureButton
var cheese_needed : RichTextLabel
var cheese : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	title = $Title
	image = $MarginContainer/VBoxContainer/TextureRect
	button = $MarginContainer2/VBoxContainer/TextureButton
	cheese_needed = $"Cheese Needed"
	cheese = GameStateManager.cheese
	focus_entered.connect(on_focus)
	focus_exited.connect(off_focus)
	if resource == null :
		title.text = "[center][font_size={25}]Locked[/font_size][/center]"
		image.texture = locked_image
		cheese_needed.text = "[center]Soon ![/center]"
		return
	if resource.necessary_cheese > cheese :
		title.text = "[center][font_size={25}]Locked[/font_size][/center]"
		image.texture = locked_image
		var cheese_diff = resource.necessary_cheese - cheese
		if cheese_diff > 0:
			cheese_needed.text = "[center][font_size={25}]%s cheese left to unlock[/font_size][/center]" % cheese_diff
		return
	image.texture = resource.map_image
	title.text = "[center][font_size={25}]%s[/font_size][/center]" % resource.title

func on_focus():
	print_debug("focus")
	button.grab_focus()
	if (! is_locked()):
		image.texture = resource.map_image_focus 
	else :
		image.texture = locked_image_focused
	
func off_focus():
	if image.texture == resource.map_image_selected:
		return
	if !is_locked():
		image.texture = resource.map_image
	else :
		image.texture = locked_image

func is_locked() :
	return resource == null or resource.necessary_cheese > cheese

func select():
	if resource != null and resource.necessary_cheese <= cheese:
		image.texture = resource.map_image_selected
		print(name)
		MapSelection.instance.switch_map(resource)
		
func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and  resource!= null and image.texture==resource.map_image_focus:
		select()
