extends Area2D

export var damage = 1



func _on_ActivateTimer_timeout():
	$Hitbox/CollisionShape2D.call_deferred("set","disabled",false)
	$Hitbox2/CollisionShape2D.call_deferred("set","disabled",false)
	$Hitbox3/CollisionShape2D.call_deferred("set","disabled",false)
	$AnimationPlayer.play("FadeAway")
	


func _on_AnimationPlayer_animation_finished(FadeAway):
	queue_free()
