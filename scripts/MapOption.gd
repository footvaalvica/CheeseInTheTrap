class_name MapOption extends  Node

@export var resource : MapResource = null
@export var locked_image : CompressedTexture2D
var button : TextureButton
var title : RichTextLabel
var cheese_needed : RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	button = $MarginContainer2/VBoxContainer/TextureButton
	title = $Title
	cheese_needed = $"Cheese Needed"
	if resource == null :
		title.text = "[center]Locked[/center]"
		button.texture_normal = locked_image
		cheese_needed.text = "[center]Soon ![/center]"
		return
	if resource.necessary_cheese > 0 :
		title.text = "[center]Locked[/center]"
		button.texture_normal = locked_image
		var cheese_diff = resource.necessary_cheese - 0
		if cheese_diff > 0:
			cheese_needed.text = "[center]%s cheese left to unlock[/center]" % cheese_diff
		return
	button.texture_normal = resource.map_image
	title.text = "[center]%s[/center]" % resource.title

func select():
	if resource != null :
		MapSelection.instance.switch_map(resource)
