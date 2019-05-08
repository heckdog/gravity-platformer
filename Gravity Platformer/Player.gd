extends KinematicBody2D

# signals
signal wham

# Declare member variables here.
var state = "down"
var impact

var gravity = 2000
export var max_walkspeed = 400
var walkspeed = 0
var velocity = Vector2()
export var terminal_velocity = 3500
var wham_count = 1

var spikes = null
var completable = false  # by default. see _ready()

# Load Global variables
onready var globals = get_node("/root/Globals")


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("player")  # allows for detection easier. also will make this work if multiplayer is added
	
	# check for existing winzone and spike group. makes it so in-dev levels dont crash
	if get_parent().has_node("WinZone"):
		completable = true
	if get_tree().has_group("spikes"):
		spikes = get_tree().get_nodes_in_group("spikes")
	# debug
	if not completable:
		print("WARNING: Level is missing WinZone. Can't complete.")
	if not spikes:
		print("No spikes detected")
	

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
	var old_speed = round(velocity.y)
	
	# actual physics
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, -terminal_velocity, terminal_velocity)
	velocity.x = round(velocity.x)
	get_input()
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	#print("V-SPEED: " + str(velocity.y))
	
	#check collisions
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var collide_name = collision.collider.name
		if collide_name != "TileMap":
			pass
			#print("Collided with: ", collide_name)  
			# use collide_name to check the name of a colision. this will stay inactive otherwise.
	
	# Hit Sound
	var new_posy = round(position.y)
	if old_posy != new_posy:
		if velocity.y == 0:
			$Impact.play()
			#print(abs(new_posy-old_posy))  # for debug
			
		# WHAM
		print(abs(old_speed-velocity.y))
		if abs(old_speed-velocity.y) >= 3100:  # 3100 is the px/s speed required to create a WHAM
			print("WHAM " + str(wham_count))
			wham_count += 1
			$Wham.play()
			emit_signal("wham")  # for wham buttons or attacks when they become a thing
			
			var cam = $Camera2D
			cam.offset.x = rand_range(0,10)
			yield(get_tree().create_timer(.1), "timeout")
			cam.offset.y = rand_range(0,25)
			yield(get_tree().create_timer(.1), "timeout")
			cam.offset.x = rand_range(-10,0)
			yield(get_tree().create_timer(.1), "timeout")
			cam.offset.y = rand_range(-20,0)
			yield(get_tree().create_timer(.1), "timeout")
			cam.offset = Vector2(0,0)
	
