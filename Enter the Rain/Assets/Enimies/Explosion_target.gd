extends Node2D
export (Resource) var Spawn
export var explosion_timer = 3

func _ready():
	$Timer.start(explosion_timer)

func _on_Timer_timeout():
	var explosion = Spawn.instance()
	explosion.position = position
	get_parent().add_child(explosion)
	queue_free()
