extends Area2D

export var damage = 0.5
export var duration = 2

func _on_Duration_timeout():
	queue_free()


func _on_Hitbox_area_entered(area):
	$Hitbox/CollisionShape2D.set_deferred("disabled",true)
	$DamageTimer.start(-1)



func _on_Timer_timeout():
	$Hitbox/CollisionShape2D.set_deferred("disabled",false)
