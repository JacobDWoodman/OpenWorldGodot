extends Node

var collectibles_collected = 0
var has_enough_drinks = false

#it doesnt work otherwise. I really wish it did. But it doesn't work otherwise...
onready var collected = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]

func collect_item():
	collectibles_collected += 1;
	get_tree().get_current_scene().get_node("CanvasLayer/txt").set_bbcode("Drinks Collected: "+ str(collectibles_collected))
	if collectibles_collected >= 30:
		has_enough_drinks = true
