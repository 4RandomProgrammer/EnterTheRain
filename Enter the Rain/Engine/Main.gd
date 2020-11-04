extends Node

var levels = {"Level1":preload("res://Assets/Areas/Area1.tscn"), "Level2":preload("res://Assets/Areas/Arena2.tscn"), "Select":preload("res://Engine/PlayerSelectScreen.tscn")}
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
	Mensageiro.stop_music()
	fase.queue_free()
	id = 0
	assert(get_tree().change_scene("res://Engine/Main.tscn") == OK)
	player.queue_free()

func setPlayer(new):
	player = new

func getPlayer():
	return player

func player_pos(pos):
	if player != null:
		player.global_position = pos
