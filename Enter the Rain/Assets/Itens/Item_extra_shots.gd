extends Node2D

var extra_prob = 2
onready var sprite = $Item_sprite.texture
onready var description = 'Aumenta a probabilidade de atirar balas extras.'


func _on_Area2D_body_entered(body):
	if body.extra_shots_probability != 0:
		extra_prob = min(2, 2.0 / body.extra_shots_probability * 10)
	body.extra_shots_probability += extra_prob
	queue_free()
