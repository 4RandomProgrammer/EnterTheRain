extends Node2D

var damage = 0.2
onready var sprite = $Item_sprite.texture
onready var description = 'Aumenta o seu dano.'

func _on_Area2D_body_entered(body):
	body.dano += damage
	queue_free()
