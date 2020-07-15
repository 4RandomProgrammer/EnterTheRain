extends Node2D

var extra_prob = 2




func _on_Area2D_body_entered(body):
	if body.extra_shots_probability != 0:
		extra_prob = min(2, 2.0 / body.extra_shots_probability * 10)
	body.extra_shots_probability += extra_prob
	queue_free()
