extends Node2D

var damage = 1

func _on_Area2D_body_entered(body):
	body.dano += damage
	queue_free()
