extends Spatial
class_name OWChunk

var x
var z
var chunkpos
var key
var should_remove = true

func _init(nx, nz, nchunkpos, nkey):
	x = nx
	z = nz
	chunkpos = nchunkpos
	key = nkey

func _ready():
	var ch = load("res://chunks/tscn/chunk"+chunkpos+".tscn")
	add_child(ch.instance())
