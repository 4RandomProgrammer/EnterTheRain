extends Node2D

var missile_prob = 2
onready var sprite = $Item_sprite.texture
onready var description = 'Aumenta a probabilidade de soltar um missil teleguiado.'

func _on_Area2D_body_entered(body):
	if body.missile_probability != 0:
		missile_prob = min(2, 2.0 / body.missile_probability * 10)
	body.missile_probability += missile_prob
	queue_free()
