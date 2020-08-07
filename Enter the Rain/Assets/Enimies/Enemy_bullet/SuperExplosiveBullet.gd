extends 'res://Assets/Enimies/Enemy_bullet/SuperBullet.gd'

onready var Explosion = load('res://Assets/Enimies/SuperExplosion.tscn')

func on_explode():
	var super_explosion = Explosion.instance()
	super_explosion.position = position
	get_parent().call_deferred('add_child', super_explosion)
