extends KinematicBody2D
signal level_complete

# Declare member variables here. Examples:
var state = "up"
var impact

var gravity = 2000
var max_walkspeed = 350
var walkspeed = 0
var velocity = Vector2()

# Load Global variables
onready var globals = get_node("/root/Globals")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

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
	var shift = Input.is_action_pressed("ui_shift")
	
	# movement w/ acceleration (accel = exponentional halves)
	if left and shift:
		walkspeed = -3 # precision move
	elif left:  # check for left after the check for shifted.
		walkspeed += (-max_walkspeed - walkspeed-1)/2  # negative average of walkspeed to max
	if right and shift:
		walkspeed = 3
	elif right:  # same check, but for right
		walkspeed += (max_walkspeed + walkspeed+1)/2  # average of walkspeed to max
	if not left or right:
		if walkspeed > 0:
			walkspeed = floor(walkspeed/2)  # divides speed by 2 until you stop. rounded down.
		elif walkspeed < 0:
			walkspeed = ceil(walkspeed/2)  # same as above, just in the case of negative numbers
	if left and right:
		walkspeed = 0
	
	# check for speeders
	if walkspeed > max_walkspeed:
		walkspeed = max_walkspeed
	velocity.x += walkspeed  # this may need a += instead of an =
	#print(velocity.x)
	
	
func _physics_process(delta):
	var old_posy = round(position.y)  # round due to sub pixel differences
	
	# actual physics
	velocity.y += gravity * delta
	velocity.x = round(velocity.x)
	get_input()
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	#check collisions
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var collide_name = collision.collider.name
		if collide_name != "TileMap":
			print("Collided with: ", collide_name)
			if collide_name == "WinZone":
				emit_signal("level_complete")
	
	# Hit Sound
	var new_posy = round(position.y)
	if old_posy != new_posy:
		if velocity.y == 0:
			$Impact.play()
	

func _on_WinZone_area_entered(area):
	emit_signal("level_complete")
	print("IN ENDZONE")
