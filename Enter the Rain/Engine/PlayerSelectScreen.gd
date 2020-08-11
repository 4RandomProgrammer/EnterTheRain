extends Control

onready var player_character_one = preload("res://Assets/Player/Trooper.tscn")
onready var player_character_two = preload("res://Assets/Player/Engineer.tscn")
onready var player_character_three = preload("res://Assets/Player/Archer.tscn")
onready var player_character_four = preload("res://Assets/Player/Bomber.tscn")


func _on_Button_pressed():
	Mensageiro.setplayer(player_character_one)
	get_tree().change_scene("res://Assets/Areas/Area1.tscn")


func _on_Button2_pressed():
	Mensageiro.setplayer(player_character_two)
	get_tree().change_scene("res://Assets/Areas/Area1.tscn")


func _on_Button3_pressed():
	Mensageiro.setplayer(player_character_three)
	get_tree().change_scene("res://Assets/Areas/Area1.tscn")


func _on_Button4_pressed():
	Mensageiro.setplayer(player_character_four)
	get_tree().change_scene("res://Assets/Areas/Area1.tscn")

