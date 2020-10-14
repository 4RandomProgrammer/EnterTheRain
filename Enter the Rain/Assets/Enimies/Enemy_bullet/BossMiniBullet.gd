extends "res://Assets/Enimies/Enemy_bullet/EnemyBullet.gd"

onready var velocity_copy = velocity

func on_pysics_loop(delta):
	velocity -= velocity_copy.normalized() * 5
