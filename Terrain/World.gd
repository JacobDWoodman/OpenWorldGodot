extends Spatial

export(String, FILE, "*.json") var file_path
export(String, FILE, "*.json") var item_file_path

const chunk_size = 41
#amount of chunks to render
const chunk_amount = 8

var chunks = {}
var unready_chunks = {}

onready var chunk_data : Array = load_chunk_data(file_path)
onready var item_data : Array = load_chunk_data(item_file_path)

var thread

func _ready():
	thread = Thread.new()

func _process(delta):
	update_chunks()
	#clean_up_chunks() # do not seem to work
	#reset_chunks() # ^^

func update_chunks():
	var p_trans = $Player.translation
	var p_x = int(p_trans.x) / chunk_size
	var p_z = int(p_trans.z) / chunk_size
	
	for x in range(p_x - chunk_amount * 0.5, p_x + chunk_amount * 0.5):
		for z in range(p_z - chunk_amount * 0.5, p_z + chunk_amount * 0.5):
			add_chunk(x, z)
			var chunk = get_chunk(x, z)
			if chunk != null:
				chunk.should_remove = false

func clean_up_chunks():
	for key in chunks:
		var chunk = chunks[key]
		if chunk.should_remove:
			chunk.queue_free()
			chunks.erase(key)

func reset_chunks():
	for key in chunks:
		chunks[key].should_remove = true

func add_chunk(x, z):
	var key = str(x) + "," + str(z)
	#if this chunk's key already exists
	#then this chunk is already loaded or is loading
	if chunks.has(key) or unready_chunks.has(key):
		return
	
	if not thread.is_active():
		load_chunk([thread, x, z])
		#thread.start(self, "load_chunk",[thread, x, z])
		unready_chunks[key] = 1

#create the chunk, give it correct params and place it in the world
func load_chunk(arr):
	var nthread = arr[0]
	var i = 0
	for arraypos in chunk_data:
		if(arraypos["x"] == arr[1]* 64 && arraypos["z"] == arr[2]* 64 ):
			#var chunk = load("res://chunks/tscn/chunk"+arraypos["path"]+".tscn")
			var chunk = OWChunk.new(arr[1], arr[2], arraypos["path"])
			chunk.translation = Vector3(arr[1] * chunk_size, 0, arr[2] * chunk_size)
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
	
	var key = chunk.key
	chunks[key] = chunk
	unready_chunks.erase(key)
	thread.wait_to_finish()

func get_chunk(x, z):
	var key = str(x) + "," + str(z)
	if chunks.has(key):
		return chunks.get(key)
	
	return null

func load_chunk_data(f_path):
	var file = File.new()
	file.open(f_path, file.READ)
	var text = parse_json(file.get_as_text())
	return text
