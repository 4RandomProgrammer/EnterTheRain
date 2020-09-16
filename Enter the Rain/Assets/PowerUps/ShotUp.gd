extends Area2D

export var damage = 0.75


func _on_ActivateTimer_timeout():
	$Sprite.visible = true
	$Sprite2.visible = false
	$Hitbox/CollisionShape2D.call_deferred("set","disabled",false)
	$Hitbox2/CollisionShape2D.call_deferred("set","disabled",false)
	$Hitbox3/CollisionShape2D.call_deferred("set","disabled",false)
	$AnimationPlayer.play("FadeAway")
	


func _on_AnimationPlayer_animation_finished(_FadeAway):
	queue_free()
