class_name MapOption extends  Node

@export var resource : MapResource = null
@export var locked_image : CompressedTexture2D
var button : TextureButton
var title : RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	button = $MarginContainer2/VBoxContainer/TextureButton
	title = $RichTextLabel
	if resource == null or resource.necessary_cheese > 0:
		title.text = "[center]Locked[/center]"
		button.texture_normal = locked_image
		return
	button.texture_normal = resource.map_image
	title.text = "[center]%s[/center]" % resource.title

func select():
	if resource != null :
		MapSelection.instance.switch_map(resource)
