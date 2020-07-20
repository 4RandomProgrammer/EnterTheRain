extends Node2D

var stun_prob = 2
onready var sprite = $Item_sprite.texture
onready var description = 'Aumenta a probabilidade de soltar um tiro atordoante.'

func _on_Area2D_body_entered(body):
	if body.stun_probability != 0:
		stun_prob = min(2, 2.0 / body.stun_probability * 10)
	body.stun_probability += stun_prob
	queue_free()
