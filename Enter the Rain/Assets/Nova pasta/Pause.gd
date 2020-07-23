extends Control

func _input(event):
	if event.is_action_pressed("Pause"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = not get_tree().paused
		visible = new_pause_state


func _on_Player_no_health():
	pass # Replace with function body.
