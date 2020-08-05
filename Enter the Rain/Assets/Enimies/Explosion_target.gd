extends Node2D
export (Resource) var Spawn


func _on_Timer_timeout():
	var explosion = Spawn.instance()
	explosion.position = position
	get_parent().add_child(explosion)
	queue_free()
