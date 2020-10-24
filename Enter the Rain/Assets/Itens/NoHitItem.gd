extends Node2D


var damage = 0.1
var atack_speed = 1 / 2000
var health_add = 1
onready var sprite = $Item_sprite.texture
onready var description = "Aumenta seu dano, velocidade de ataque e vida máxima !"


func _on_NoHitItem_body_entered(body):
	body.dano += damage
	body.set_MaxHealth(health_add)
	body.set_NewHealth(health_add)
	body.fire_rate -= atack_speed
	queue_free()
