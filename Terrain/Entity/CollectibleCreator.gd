extends Spatial
class_name Collectible

var index_pos

func _init(index):
	index_pos = index

# Called when the node enters the scene tree for the first time.
func _ready():
	var ch = load("res://Terrain/Entity/Collectible.tscn").instance()
	ch.index_pos = index_pos
	add_child(ch)
