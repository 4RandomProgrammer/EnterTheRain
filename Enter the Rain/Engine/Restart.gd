extends Node2D

var player

func _ready():
	player = Mensageiro.getplayer().instance()
	add_child(player)
	move_child(player,2)
	player.global_position = Vector2(80,65)
	player.connect("healthChanged",$SeguePlayer/Camera2D/CanvasLayer/HealthBar,"_on_Player_healthChanged")
	player.connect("maxhealthChanged",$SeguePlayer/Camera2D/CanvasLayer/HealthBar,"_on_Player_maxhealthChanged")


func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().reload_current_scene()
	if is_instance_valid(player):
		$SeguePlayer.global_position = player.global_position
