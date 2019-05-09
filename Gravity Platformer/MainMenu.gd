extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartButton.connect("pressed", self, "_on_StartButton_pressed")
	$ControlsButton.connect("pressed", self, "_on_ControlsButton_pressed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_StartButton_pressed():
	print("STARTING GAME")
	get_tree().change_scene("res://maps/Map1.tscn")
	
func _on_ControlsButton_pressed():
	print("Controls Menu")
	get_tree().change_scene("res://Demo.tscn")
