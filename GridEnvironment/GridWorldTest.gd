extends Spatial

export(String, FILE, "*.json") var file_path
export(String, FILE, "*.json") var item_file_path

export var worldSize : Vector2
export var halfChunkLength : float
export var chunkRenderDistance : int
var grid

onready var chunk_data : Array = load_chunk_data(file_path)
onready var item_data : Array = load_chunk_data(item_file_path)

var chunks = {}
var unready_chunks = {}

var nearby_nodes = []
var loaded_nodes = []
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
		var chunk = get_chunk(nnode.worldPos)
		if chunk != null:
			chunk.should_remove = false

func create_chunk(node):
	var key = str(node.worldPos)
	if chunks.has(key) or unready_chunks.has(key):
		return
	
	if not thread.is_active():
		thread.start(self, "load_chunk",[thread, node])
		unready_chunks[key] = 1

func get_chunk(pos):
	var key = str(pos)
	if chunks.has(key):
		return chunks.get(key)
	
	return null

func load_chunk(arr):
	var nthread = arr[0]#more readable this way
	var node = arr[1]
	var i = 0
	for arraypos in chunk_data:
		if(arraypos["x"] == node.gridX && arraypos["z"] == node.gridZ ):
			var chunk = OWChunk.new(node.gridX, node.gridZ, arraypos["path"], str(node.worldPos))
			chunk.translation = arr[1].worldPos
			var item
			if(!GameStats.collected[i]):
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
	add_child(chunk)
	if(item != null):
		chunk.add_child(item)
	
	var key = chunk.key
	chunks[key] = chunk
	unready_chunks.erase(key)
	loaded_nodes.append(chunk.translation)
	thread.wait_to_finish()

func clean_up_chunks():
	for key in chunks:
		var chunk = chunks[key]
		if chunk.should_remove:
			chunk.queue_free()
			chunks.erase(key)

func reset_chunks():
	for key in chunks:
		chunks[key].should_remove = true

func load_chunk_data(f_path):
	var file = File.new()
	file.open(f_path, file.READ)
	var text = parse_json(file.get_as_text())
	return text
