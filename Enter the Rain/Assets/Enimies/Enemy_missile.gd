extends "res://Assets/Shot/MissileBullet.gd"

func _on_Timer_timeout():
	create_explosion()
	queue_free()

func _on_HurtBox_body_entered(body):
	create_explosion()
	body.queue_free()
	queue_free()

