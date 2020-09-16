extends RigidBody2D

onready var explosion = $Hitbox/CollisionShape2D

const BULLETSPEED = 200

var damage = 1

func _ready():
	$Timer.start()

func _on_Granada_body_entered(_body):
	explosion.call_deferred("set","disabled", false)
	$AnimationPlayer.play("Explosion")

func _on_AnimationPlayer_animation_finished(_Explosion):
	queue_free()

func _on_Timer_timeout():
	explosion.call_deferred("set","disabled", false)
	$AnimationPlayer.play("Explosion")
	
