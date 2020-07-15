extends Node2D

var stun_prob = 2

func _on_Area2D_body_entered(body):
	if body.stun_probability != 0:
		stun_prob = min(2, 2.0 / body.stun_probability * 10)
	body.stun_probability += stun_prob
	emit_signal("maxhealthChanged", 1)
	queue_free()
