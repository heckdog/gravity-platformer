extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().get_parent().has_node("LevelBound"):  # double get parent because its a child of PLayer and not root
		var bound = get_parent().get_parent().get_node("LevelBound")
		limit_right = bound.position.x
		limit_bottom = bound.position.y
	else:
		print("INFO: Level has no limit, camera free.")
		limit_left = -1000000
		limit_top = -1000000

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
