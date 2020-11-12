extends Control

onready var description = $Description

func _on_Panel_mouse_entered():
	description.visible = true

func _on_Panel_mouse_exited():
	description.visible = false

