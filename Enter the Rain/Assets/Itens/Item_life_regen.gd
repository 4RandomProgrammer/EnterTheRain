extends Node2D

var life = 1
onready var sprite = $Item_sprite.texture
var description = 'Recupera a sua vida'

func _on_Area2D_body_entered(body):
	if body.Health < body.MaxHealth:
		body.set_NewHealth(life)
		queue_free()
