extends StaticBody2D

# Declare member variables here. Examples:
export var activator = "Button"
var state = "open"
var old_shape = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().has_node(activator):
		var butt_path = get_node("../" + activator)
		print(name + " is linked to " + activator)
		butt_path.connect("pressed", self, "_on_Button_Pressed")
	else:
		print("UNLINKED BUTTON")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_Pressed():
	print("DOOR OPEN")
	$anim.animation = "rising"
	$BottomDoorCollision.shape = null
	