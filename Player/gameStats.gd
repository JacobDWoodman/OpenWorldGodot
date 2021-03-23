extends Node

var collectibles_collected = 0

#it doesnt work otherwise. I really wish it did. But it doesn't work otherwise...
onready var collected = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]

#func ready():
#	set_bool_array(collected, false)

#func set_bool_array(array, value):
#	for i in range(0, 36):
#		array[i] = value

func collect_item():
	collectibles_collected += 1;
	get_tree().get_current_scene().get_node("CanvasLayer/txt").set_bbcode("Drinks Collected: "+ str(collectibles_collected))
