extends Spatial
class_name Dude

# Called when the node enters the scene tree for the first time.
func _ready():
	var ch = load("res://Terrain/Entity/Dude.tscn")
	add_child(ch.instance())
