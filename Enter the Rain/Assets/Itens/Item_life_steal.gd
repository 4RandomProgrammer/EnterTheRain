extends Node2D

var life_steal_prob = 2
onready var sprite = $Item_sprite.texture
var description = "Aumenta a probabilidade dos inimigos droparem vida quando morrerem."


func _on_LifeSteal_body_entered(body):
	if body.health_drop_probability != 0:
		life_steal_prob = min(2, 2.0 / body.health_drop_probability * 10)
	body.health_drop_probability += life_steal_prob
	queue_free()
