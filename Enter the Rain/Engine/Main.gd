extends Node

var levels = {"Level1":preload("res://Assets/Areas/Area1.tscn"), "Level2":preload("res://Arena2.tscn")}
var player setget setPlayer, getPlayer

func sumirUi():
	$PlayerSelectScreen.queue_free()

func instanciarlevel():
	var level = levels["Level1"].instance()
	get_parent().add_child(level)

func setPlayer(new):
	player = new

func getPlayer():
	return player
