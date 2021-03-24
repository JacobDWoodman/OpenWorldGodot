extends Node
class_name EnvironmentNode

var worldPos : Vector3
var gridX : int
var gridZ : int

func _init(_worldPos, _gridX, _gridZ):
	worldPos = _worldPos
	gridX = _gridX
	gridZ = _gridZ
