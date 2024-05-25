class_name MapOption extends  Control

@export var resource : MapResource = null
@export var locked_image : CompressedTexture2D
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
	if resource == null :
		title.text = "[center]Locked[/center]"
		image.texture = locked_image
		cheese_needed.text = "[center]Soon ![/center]"
		return
	if resource.necessary_cheese > cheese :
		title.text = "[center]Locked[/center]"
		image.texture = locked_image
		var cheese_diff = resource.necessary_cheese - cheese
		if cheese_diff > 0:
			cheese_needed.text = "[center]%s cheese left to unlock[/center]" % cheese_diff
		return
	image.texture = resource.map_image
	title.text = "[center]%s[/center]" % resource.title

func on_focus():
	print_debug("focus")
	button.grab_focus()
	
func select():
	if resource != null and resource.necessary_cheese <= GameStateManager.cheese:
		MapSelection.instance.switch_map(resource)
