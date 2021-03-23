extends Node

export(String, FILE, "*.json") var file_path

var NameTag
#var CharIcon
var Text
onready var dialogue : Array = load_dialogue(file_path)
var page = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#var txtbox = get_child(1)
	#CharIcon = get_child(0).get_child(1)
	NameTag = $Label
	Text = $RichTextLabel
	update_talk()
	set_process_input(true)

func _input(_event):
	if Input.is_action_just_pressed("select"):
		if Text.all_text_visible():
			if page < dialogue.size() - 1:
				page += 1
				update_talk()
			else: present_options()
		else: 
			Text.set_all_text_visible()
			end_talking()

func update_talk():
	Text.update_talk(dialogue[page]['line'])
	NameTag.text = dialogue[page]['name']
	#CharIcon.play(dialogue[page]['expression']+" Speak")

func end_talking():
	#CharIcon.play(dialogue[page]['expression'])
	pass

func load_dialogue(f_path):
	var file = File.new()
	file.open(f_path, file.READ)
	var text = parse_json(file.get_as_text())
	return text

func present_options():
	pass
	#enabling clickable buttons which loads new dialogue goes here

func _on_Timer_timeout():
	if Text.get_visible_characters() < Text.get_total_character_count():
		Text.set_visible_characters(Text.get_visible_characters() + 1)
	else: end_talking()
