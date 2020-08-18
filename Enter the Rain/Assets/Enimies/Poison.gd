extends Area2D

var damage = 1


func _on_Timer_dano_timeout():
	print('dar dano')
	$Hitbox.get_node("CollisionShape2D").set_deferred('disabled', false)


func _on_Veneno_body_entered(body):
	print('entrou')
	$Timer_dano.start()


func _on_Veneno_body_exited(body):
	$Timer_dano.stop()
	$Hitbox.get_node("CollisionShape2D").set_deferred('disabled', true)


func _on_Timer_sumir_timeout():
	queue_free()
