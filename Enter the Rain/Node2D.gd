extends Node2D


export (int) var dano = 0
export (int) var velocidade = 0

func _on_Area2D_body_entered(body):
	body.MAX_SPEED += velocidade
	body.dano += dano
	queue_free()
