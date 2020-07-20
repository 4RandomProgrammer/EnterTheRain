extends Node2D

var speed = 10
onready var sprite = $Item_sprite.texture
onready var description = 'Aumenta a sua velocidade de movimento.'

func _on_Area2D_body_entered(body):
	body.MAX_SPEED += speed
	queue_free()
	
