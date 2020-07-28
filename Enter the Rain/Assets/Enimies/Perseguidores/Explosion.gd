extends Area2D

export var DAMAGE = 1

func _on_Timer_timeout():
	queue_free()
