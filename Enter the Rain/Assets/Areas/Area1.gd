extends Node2D

var main

func _ready():
	main = get_parent()
	main.player_pos(Vector2(80,65))

func _on_LvChanger_changeLv():
	main = get_parent()
	main.instanciarlevel()
