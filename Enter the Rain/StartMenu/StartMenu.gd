extends Control



func _on_Start_pressed():
	assert(get_tree().change_scene("res://Engine/Main.tscn") == OK)


func _on_Quit_pressed():
	get_tree().quit()


func _on_Creditos_pressed():
	$Creditos.visible = true


func _on_Button_pressed():
	$Creditos.visible = false
