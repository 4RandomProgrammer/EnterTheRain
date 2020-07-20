extends Node2D
signal atack_speed

var atack_speed = 1 / 1000
onready var sprite = $Item_sprite.texture
onready var description = 'Aumenta a sua velocidade de ataque.'

func _on_Area2D_body_entered(body):
	body.fire_rate -= atack_speed
	queue_free()
