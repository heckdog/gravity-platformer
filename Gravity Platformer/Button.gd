extends Area2D

signal pressed
var is_pressed = false

# Declare member variables here. Examples:
var player
export var target = "Door"

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().has_node("Player"):
		var player = "../Player"
	else:
		print("WARNING: Player not found in level for Button.")
	connect("body_entered", self, "_on_Button_body_entered")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_body_entered(body):
	if body.name == "Player" and not is_pressed:
		print("Button Pressed at: " + str(position))  # just for reference
		$anim.animation = "pressed"
		$Beep.play()
		emit_signal("pressed")
		is_pressed = true
