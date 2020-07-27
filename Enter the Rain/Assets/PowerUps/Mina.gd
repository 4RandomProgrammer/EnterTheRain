extends Area2D

onready var Anim = $AnimationPlayer
export var damage = 2

func _ready():
	Anim.play("Beeping")
	$BlowTimer.start(3)

func _on_BlowTimer_timeout():
	Anim.play("Explosion")

func _on_AnimationPlayer_animation_finished(_Explosion):
	queue_free()

func _on_HurtBox_body_entered(_body):
	Anim.play("Explosion")
