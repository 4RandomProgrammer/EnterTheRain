extends Area2D

var damage = 1


func _on_Veneno_body_entered(body):
	if body.name == 'Player':
		body.quant_poison += 1


func _on_Veneno_body_exited(body):
	if body.name == 'Player':
		body.quant_poison -= 1


func _on_Timer_sumir_timeout():
	queue_free()
