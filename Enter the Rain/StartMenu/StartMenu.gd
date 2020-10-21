extends Control



func _on_Start_pressed():
	get_tree().change_scene("res://Engine/PlayerSelectScreen.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Creditos_pressed():
	$ColorRect.visible = true
