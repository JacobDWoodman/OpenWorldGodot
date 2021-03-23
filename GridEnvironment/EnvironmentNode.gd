extends Node
class_name EnvironmentNode

var worldPos : Vector3
var gridX : int
var gridY : int

func _init(_worldPos, _gridX, _gridY):
	worldPos = _worldPos
	gridX = _gridX
	gridY = _gridY
