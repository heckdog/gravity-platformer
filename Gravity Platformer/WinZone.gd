extends Area2D

export var next_level = "Map2"
onready var player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	next_level = "res://maps/%s.tscn" % next_level
	player.connect("level_complete", self, "_on_Player_level_complete")
	connect("body_entered", self, "_on_WinZone_body_entered")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# this doesnt work bc areas dont detect collisons. see below instead
func _on_Player_level_complete():
	get_tree().change_scene(next_level)
	

func _on_WinZone_body_entered(body):
	if body.is_in_group("player"):
		print("PLAYER REACHED END\n")
		get_tree().change_scene(next_level)