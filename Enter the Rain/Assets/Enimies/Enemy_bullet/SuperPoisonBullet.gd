extends "res://Assets/Enimies/Enemy_bullet/EnemyBullet.gd"

onready var Poison = load("res://Assets/Enimies/Poison.tscn")

func _ready():
	randomize()
	$Timer_poison.start(rand_range(0.3, 0.6))

func _on_Timer_poison_timeout():
	var poison = Poison.instance()
	poison.position = global_position
	get_parent().call_deferred('add_child', poison)
	$Timer_poison.start(rand_range(0.3, 0.6))

