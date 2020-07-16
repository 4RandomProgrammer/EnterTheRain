extends Control

onready var player_character_one = preload("res://Assets/Player/Player.tscn")
var player_character_two = -1


func _on_Button_pressed():
	Mensageiro.setplayer(player_character_one)
	get_tree().change_scene("res://Assets/Areas/Area1.tscn")


func _on_Button2_pressed():
	#player vai ser o personagem 2, a definir
	pass # Replace with function body.
