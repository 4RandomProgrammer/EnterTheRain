extends Area2D

func _on_Timer_timeout():
	queue_free()

func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		body.MAX_SPEED = 100

func _on_Area2D_body_exited(body):
	if body.name == 'Player':
		body.MAX_SPEED = 250
