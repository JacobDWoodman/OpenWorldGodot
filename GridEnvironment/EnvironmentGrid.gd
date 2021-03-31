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
			i += 1

func getNeighbours(node, distance):
	var neighbours = []
	
	for x in range(-distance, distance+1):
		for z in range(-distance, distance+1):
			var checkX = node.gridX + x
			var checkZ = node.gridZ + z
			if(checkX >= 0 && checkX < gridSizeX && checkZ >= 0 && checkZ < gridSizeZ):
				for noode in grid:
					if (noode.gridX == checkX && noode.gridZ == checkZ):
						neighbours.append(noode)
	return neighbours

func NodeFromWorldPoint(worldPosition):
	var percent = Vector2((worldPosition.x + gridWorldSize.x/2)/gridWorldSize.x, ((worldPosition.z * -1) + gridWorldSize.y/2)/gridWorldSize.y)
	
	percent.x = clamp(percent.x, 0, 1)
	percent.y = clamp(percent.y, 0, 1)
	
	var x = int(round((gridSizeX - 1) * percent.x))
	var z = int(round((gridSizeZ - 1) * percent.y))
	
	for nnode in grid:
		if(nnode.gridX == x && nnode.gridZ == z):
			return nnode
















