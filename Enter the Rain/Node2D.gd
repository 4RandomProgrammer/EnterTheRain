extends Node2D


export (float) var dano = 0
export (float) var velocidade = 0
export (float) var atack_speed = 0

export (Resource) var sprite = load("res://Assets/Itens/espada.png")

func _ready():
	$Item_sprite.texture = sprite
	

func _on_Area2D_body_entered(body):
	# Atualizar os dados do player quando ele pegar um item.
	body.fire_rate -= atack_speed / 1000
	if body.fire_rate <= 0:  # Não deixar o fire rate negativo.
		body.fire_rate = 0
	body.MAX_SPEED += velocidade
	body.dano += dano
	queue_free()
