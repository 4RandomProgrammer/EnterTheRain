extends Node2D

var speed = 10

func _on_Area2D_body_entered(body):
	body.MAX_SPEED += speed
	queue_free()
	
