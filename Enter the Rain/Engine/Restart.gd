extends Node2D

var player

func _ready():
	if Mensageiro.getstart():
		player = Mensageiro.getplayer().instance()
		add_child(player)
		move_child(player,2)
		player.global_position = Vector2(80,65)
		Mensageiro.setstart(false)
	else:
		add_child(Mensageiro.getplayer())

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().reload_current_scene()
