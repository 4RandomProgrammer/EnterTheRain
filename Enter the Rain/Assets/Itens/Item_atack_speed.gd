extends Node2D
signal atack_speed

var atack_speed = 1 / 1000

func _on_Area2D_body_entered(body):
	body.fire_rate -= atack_speed
	queue_free()
