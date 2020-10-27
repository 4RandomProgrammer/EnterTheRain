extends Node

var levels = {"Level1":preload("res://Assets/Areas/Area1.tscn"), "Level2":preload("res://Arena2.tscn"), "Select":preload("res://Engine/PlayerSelectScreen.tscn")}
var player setget setPlayer, getPlayer
var id = 0
var fase = null

func sumirUi():
	$PlayerSelectScreen.queue_free()

func instanciarlevel():
	if fase != null:
		fase.queue_free()
	match id:
		0:
			fase = levels["Level1"].instance()
			Mensageiro.playmusic(0)
		1:
			fase = levels["Level2"].instance()
		2:
			pass

	id += (id + 1) % 4
	self.add_child(fase)

func select():
	fase.queue_free()
	id = 0
	get_tree().change_scene("res://Engine/Main.tscn")
	player.queue_free()

func setPlayer(new):
	player = new

func getPlayer():
	return player

func player_pos(pos):
	if player != null:
		player.global_position = pos
