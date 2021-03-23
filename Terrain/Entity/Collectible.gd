extends Spatial

var index_pos
var rotatespeed = 3
onready var i = randi() % 3
var mesh_to_load

# Called when the node enters the scene tree for the first time.
func _ready():
	match i:
		0: mesh_to_load = preload("res://models/bottles.tres")
		1: mesh_to_load = preload("res://models/coffee.tres")
		2: mesh_to_load = preload("res://models/cola.tres")
	$MeshInstance.mesh = mesh_to_load

func _process(delta):
	rotate_y(rotatespeed * delta)

func _on_Area_body_entered(body):
	GameStats.collected[index_pos] = true
	GameStats.collect_item()
	queue_free()
