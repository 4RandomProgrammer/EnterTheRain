extends Node2D


export (float) var dano = 1
export (float) var velocidade = 50
export (float) var atack_speed = 50

export (Resource) var sprite = load("res://Assets/Itens/espada.png")

func _ready():
	$Item_sprite.texture = sprite
	

func _on_Area2D_body_entered(body):
	body.fire_rate -= atack_speed / 1000
	if body.fire_rate <= 0:
		body.fire_rate = 0
	body.MAX_SPEED += velocidade
	body.dano += dano
	queue_free()
