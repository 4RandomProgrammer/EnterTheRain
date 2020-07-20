extends Node2D

var start_health = 5
onready var sprite = $Item_sprite.texture
onready var description = 'Aumenta a sua vida máxima.'


func _on_Area2D_body_entered(body):
	var health = min(5, 100 / body.MaxHealth)
	body.set_MaxHealth(health)
	body.set_NewHealth(health)
	print(body.MaxHealth)
	queue_free()
