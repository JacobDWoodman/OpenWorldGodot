extends Node
class_name EnvironmentGrid

export var gridWorldSize : Vector2
export var nodeRadius : float

var grid = []

var gridSizeX : int
var gridSizeZ : int
var nodeDiameter : float
var position : Vector3

func _init(_gridWorldSize, _nodeRadius, _position):
	gridWorldSize = _gridWorldSize
	nodeRadius = _nodeRadius
	nodeDiameter = nodeRadius * 2
	gridSizeX = int(round(gridWorldSize.x / nodeDiameter))
	gridSizeZ = int(round(gridWorldSize.y / nodeDiameter))
	createGrid()

func createGrid():
	
	var worldBottomLeft = position - Vector3.RIGHT * gridWorldSize.x / 2 - Vector3.FORWARD * gridWorldSize.y / 2
	var i = 0
	for x in gridSizeX:
		for z in gridSizeZ:
			var worldPoint = worldBottomLeft + Vector3.RIGHT * (x * nodeDiameter + nodeRadius) + Vector3.FORWARD * (z * nodeDiameter + nodeRadius)
			grid.append(EnvironmentNode.new(worldPoint, x, z))
			print("made new node at (" + str(x) + ", " + str(z) + ")" + str(i))
			i += 1

