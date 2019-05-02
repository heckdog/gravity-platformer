extends KinematicBody2D

# Declare member variables here. Examples:
var state = "up"
var impact

var gravity = 2500
var walkspeed = 350
var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		# flip the animation
		if $PlayerSprite.animation == "down":
			$PlayerSprite.animation = "up"
			state = "up"
		else:
			$PlayerSprite.animation = "down"
			state = "down"
		
		$FlipSound.play()

# gets inputs
func get_input():
	#gravity shift
	if state == "up":
		gravity = -2500
	else:
		gravity = 2500
		
	velocity.x = 0
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	
	if left:
		velocity.x += -walkspeed
	if right:
		velocity.x += walkspeed
		
	
	
func _physics_process(delta):
	var old_posy = round(position.y)  # round due to sub pixel differences
	
	# actual physics
	velocity.y += gravity * delta
	get_input()
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	$Label.text = str(old_posy)  # debug
	# Hit Sound
	var new_posy = round(position.y)
	if old_posy != new_posy:
		if velocity.y == 0:
			$Impact.play()
	