extends Control

onready var main = get_parent().get_parent().get_parent().get_parent()

func _on_Button_pressed():
	main.select()
	self.visible = false
