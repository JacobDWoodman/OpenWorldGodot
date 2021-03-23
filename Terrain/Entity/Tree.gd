extends Spatial
class_name TreeEntity

var x
var y
var z

var key

#creates a tree instance using these params
func _init(x, y, z):
	self.x = x
	self.y = y
	self.z = z

func _ready():
	generate_tree()

func generate_tree():
	var mesh = CubeMesh.new()
