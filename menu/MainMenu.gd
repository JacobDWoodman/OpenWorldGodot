extends Control

func _on_PlayB_pressed():
	get_tree().change_scene("res://GridEnvironment/testGridWorld.tscn")


func _on_Quit_pressed():
	get_tree().quit()
