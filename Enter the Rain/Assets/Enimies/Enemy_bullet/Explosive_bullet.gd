extends "res://Assets/Enimies/Enemy_bullet/EnemyBullet.gd"

export (Resource) var explosion

func on_collision():
	var Explosion = explosion.instance()
	Explosion.position = position
	get_parent().call_deferred('add_child', Explosion)
