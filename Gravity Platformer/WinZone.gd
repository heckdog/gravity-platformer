extends Area2D

export var next_level = "Map2"
onready var player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	next_level = "res://maps/%s.tscn"
	player.connect("level_complete", self, "_on_Player_level_complete")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Player_level_complete():
	get_tree().change_scene(next_level)
