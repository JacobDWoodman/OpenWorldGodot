extends Spatial

var dialogue = preload("res://Dialogue/Dialogue.tscn")
var doug

func _on_Area_body_entered(body):
	if(body.get_name() == "Player"):
		print(body.get_name())
		doug = dialogue.instance()
		get_tree().get_current_scene().get_node("CanvasLayer").add_child(doug)

func _on_Area_body_exited(body):
	if(body.get_name() == "Player"):
		doug.queue_free() #http://i.imgur.com/Xy0VYlk.png
