extends Control

# Load Global variables
onready var globals = get_node("/root/Globals")
var lives

# Called when the node enters the scene tree for the first time.
func _ready():
	lives = globals.player["lives"]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lives = globals.player["lives"]
	$Label.text = "LIVES:%s" % lives
