extends StaticBody2D

# Declare member variables here. Examples:
export var activator = "Button"
var state = "open"
var activated = false
var old_shape = null
var door_bottom

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().has_node(activator):
		var butt_path = get_node("../" + activator)
		print(name + " is linked to " + activator)
		butt_path.connect("pressed", self, "_on_Button_Pressed")
	else:
		print("UNLINKED BUTTON")
	
	# init detection area
	$DetectionArea.connect("body_entered", self, "_on_DetectionArea_body_entered")
	$DetectionArea.connect("body_exited", self, "_on_DetectionArea_body_exited")
	
	door_bottom = $BottomDoorCollision.shape  # storage for close()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_Pressed():
	print("DOOR ACTIVATED")
	activated = true
	open_door()
	

func _on_DetectionArea_body_entered(body):
	if body.name == "Player":
		print("Player in area")
		if activated:
			open_door()
			
			
func _on_DetectionArea_body_exited(body):
	if body.name == "Player":
		print("Player left area")
		if activated:
			close_door()

# open the door for player
func open_door():
	state = "open"
	$anim.animation = "rising"
	$BottomDoorCollision.shape = null
	
	
# close door and re add collision
func close_door():
	state = "closed"
	$anim.animation = "closing"
	$BottomDoorCollision.shape = door_bottom
	
	
