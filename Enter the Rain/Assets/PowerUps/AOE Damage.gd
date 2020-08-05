extends Area2D

export var damage = 1
export var duration = 2

func _on_Duration_timeout():
	queue_free()
