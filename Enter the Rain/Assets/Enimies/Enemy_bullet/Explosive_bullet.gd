extends "res://Assets/Enimies/Enemy_bullet/EnemyBullet.gd"

onready var explosion = load("res://Assets/Enimies/Explosion.tscn")

func on_collision():
	var Explosion = explosion.instance()
	Explosion.position = position
	get_parent().add_child(Explosion)
