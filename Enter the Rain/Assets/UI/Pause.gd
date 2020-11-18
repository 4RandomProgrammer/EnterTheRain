extends Control

onready var main = get_parent().get_parent().get_parent().get_parent()

func _input(event):
	if event.is_action_pressed("Pause"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = not get_tree().paused
		visible = new_pause_state


func _on_Player_no_health():
	pass # Replace with function body.


func _on_CharSelect_pressed():
	get_tree().paused = not get_tree().paused
	main.select()


func _on_Menu_pressed():
	get_tree().paused = not get_tree().paused
	assert(get_tree().change_scene("res://StartMenu/StartMenu.tscn") == OK)
