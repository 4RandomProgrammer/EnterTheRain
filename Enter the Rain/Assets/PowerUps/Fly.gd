extends Area2D

var damage = 1

func _ready():
	$AnimationPlayer.play("Explosion")

#Area para knockback
func _on_Fly_body_entered(body):
	body.to_knockback(global_transform.origin)


func _on_AnimationPlayer_animation_finished(_Explosion):
	queue_free()
