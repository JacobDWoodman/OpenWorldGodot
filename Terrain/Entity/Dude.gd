extends Spatial

var dialogue = preload("res://Dialogue/Dialogue.tscn")
var completed_dialogue = preload("res://Dialogue/CompletedDialogue.tscn")
var doug

func _on_Area_body_entered(body):
	if(body.get_name() == "Player"):
		if GameStats.has_enough_drinks:
			doug = completed_dialogue.instance()
		else:
			doug = dialogue.instance()
		get_tree().get_current_scene().get_node("CanvasLayer").add_child(doug)

func _on_Area_body_exited(body):
	if(body.get_name() == "Player"):
		doug.queue_free()
	if GameStats.has_enough_drinks:
		get_tree().change_scene("res://path/to/scene.tscn")
