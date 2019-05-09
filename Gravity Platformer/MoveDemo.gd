extends Sprite

# Declare member variables here. Examples:
var start = position.x
var end = position.x + 100
var going_back = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	# check that we're in the 100px range
	if position.x >= end:
		going_back = true
	elif position.x <= start:
		going_back = false
		
	if position.x <= end and going_back == false:
		position.x += 1
	else:
		position.x -= 1
