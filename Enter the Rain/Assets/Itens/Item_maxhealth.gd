extends Node2D

var health = 1

func _on_Area2D_body_entered(body):
	body.set_MaxHealth(health)
	body.set_NewHealth(health)
	queue_free()
