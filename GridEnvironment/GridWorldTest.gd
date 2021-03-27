extends Spatial

export(String, FILE, "*.json") var file_path
export(String, FILE, "*.json") var item_file_path

export var worldSize : Vector2
export var halfChunkLength : float
export var chunkRenderDistance : int
var grid

onready var chunk_data : Array = load_chunk_data(file_path)
onready var item_data : Array = load_chunk_data(item_file_path)

var nearby_nodes = []
var loaded_nodes = []
var loaded_chunks = []
var thread

# Called when the node enters the scene tree for the first time.
func _ready():
	thread = Thread.new()
	grid = EnvironmentGrid.new(worldSize, halfChunkLength, self.translation)

func _process(delta):
	update_chunks()
	clean_up_chunks()
	reset_chunks()


func update_chunks():
	var p_trans = grid.NodeFromWorldPoint($Player.translation)
	
	for nnode in grid.getNeighbours(p_trans, chunkRenderDistance):
		nearby_nodes.append(nnode)
		create_chunk(nnode)

func create_chunk(node):
	if loaded_nodes.has(node.worldPos):
		return #dont make a chunk that already exists
	
	thread.start(self, "load_chunk",[thread, node])

func load_chunk(arr):
	var nthread = arr[0]#more readable this way
	var node = arr[1]
	var i = 0
	for arraypos in chunk_data:
		if(arraypos["x"] == node.gridX && arraypos["z"] == node.gridZ ):
			var chunk = OWChunk.new(node.gridX, node.gridZ, arraypos["path"])
			chunk.translation = arr[1].worldPos
			var item
			if(item_data[i]["exists"] && !GameStats.collected[i]):
				match item_data[i]["obj"]:
					"item":
						item = Collectible.new(i)
					"NPC":
						item = Dude.new()
				item.translation = Vector3(item_data[i]["position"]["x"],item_data[i]["position"]["y"],item_data[i]["position"]["z"])
			call_deferred("load_done", chunk, item, nthread)
			break
		else: i += 1

func load_done(chunk, item, thread):
	print("lez goooo")
	add_child(chunk)
	chunk.add_child(item)
	loaded_nodes.append(chunk.translation)
	loaded_chunks.append(chunk)
	thread.wait_to_finish()

func clean_up_chunks0():
	var i = 0
	
	for chunktr in loaded_nodes:
		var in_range = false
		for node in nearby_nodes:
			if node.worldPos == chunktr:
				var pos = node.worldPos
				in_range = true
		if !in_range:
			loaded_nodes.erase(chunktr)
			loaded_chunks[i].queue_free()
		i += 1

func clean_up_chunks():
	for chunk in loaded_chunks:
		for node in nearby_nodes:
			if(chunk.translation == node.worldPos):
				chunk.should_remove = false
				break
			if (chunk.should_remove):
				chunk.queue_free()
				loaded_chunks.erase(chunk)

func reset_chunks():
	for chunk in loaded_chunks:
		chunk.should_remove = true

func load_chunk_data(f_path):
	var file = File.new()
	file.open(f_path, file.READ)
	var text = parse_json(file.get_as_text())
	return text
