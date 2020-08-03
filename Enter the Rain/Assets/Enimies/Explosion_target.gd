extends Node2D
onready var Explosion = load("res://Assets/Enimies/Explosion.tscn")


func _on_Timer_timeout():
	var explosion = Explosion.instance()
	explosion.position = position
	get_parent().add_child(explosion)
	queue_free()
