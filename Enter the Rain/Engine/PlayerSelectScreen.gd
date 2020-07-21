extends Control

onready var player_character_one = preload("res://Assets/Player/Player.tscn")
onready var player_character_two = preload("res://Assets/Player/Player2.tscn")


func _on_Button_pressed():
	Mensageiro.setplayer(player_character_one)
	get_tree().change_scene("res://Assets/Areas/Area1.tscn")


func _on_Button2_pressed():
	Mensageiro.setplayer(player_character_two)
	get_tree().change_scene("res://Assets/Areas/Area1.tscn")
