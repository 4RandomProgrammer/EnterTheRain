extends Control

onready var player_character_one = preload("res://Assets/Player/Trooper.tscn")
onready var player_character_two = preload("res://Assets/Player/Engineer.tscn")
onready var player_character_three = preload("res://Assets/Player/Archer.tscn")
onready var player_character_four = preload("res://Assets/Player/Bomber.tscn")
onready var main = get_parent()

var player_selected = null

func _on_Button_pressed():
	player_selected = player_character_one
	$MarginContainer/VBoxContainer/Sprite.visible = true
	$MarginContainer/VBoxContainer/Sprite2.visible = false
	$MarginContainer/VBoxContainer/Sprite3.visible = false
	$MarginContainer/VBoxContainer/Sprite4.visible = false
	$TextureButton.visible = true

func _on_Button2_pressed():
	player_selected = player_character_two
	$MarginContainer/VBoxContainer/Sprite.visible = false
	$MarginContainer/VBoxContainer/Sprite2.visible = true
	$MarginContainer/VBoxContainer/Sprite3.visible = false
	$MarginContainer/VBoxContainer/Sprite4.visible = false
	$TextureButton.visible = true

func _on_Button3_pressed():
	player_selected = player_character_three
	$MarginContainer/VBoxContainer/Sprite.visible = false
	$MarginContainer/VBoxContainer/Sprite2.visible = false
	$MarginContainer/VBoxContainer/Sprite3.visible = true
	$MarginContainer/VBoxContainer/Sprite4.visible = false
	$TextureButton.visible = true

func _on_Button4_pressed():
	player_selected = player_character_four
	$MarginContainer/VBoxContainer/Sprite.visible = false
	$MarginContainer/VBoxContainer/Sprite2.visible = false
	$MarginContainer/VBoxContainer/Sprite3.visible = false
	$MarginContainer/VBoxContainer/Sprite4.visible = true
	$TextureButton.visible = true

func _on_TextureButton_pressed():
	player_selected = player_selected.instance()
	main.setPlayer(player_selected)
	main.add_child(player_selected)
	main.instanciarlevel()
	main.sumirUi()
