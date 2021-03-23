extends Spatial


export var worldSize : Vector2
export var halfChunkLength : float
var grid


# Called when the node enters the scene tree for the first time.
func _ready():
	grid = EnvironmentGrid.new(worldSize, halfChunkLength, self.translation)
