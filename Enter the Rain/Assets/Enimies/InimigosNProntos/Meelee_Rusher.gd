extends "res://Assets/Enimies/InimigosNProntos/Enemy_attack_base.gd"

func chase():
	direction = global_position.direction_to(enemy_range.target.global_position)
	velocity = velocity.move_toward(direction * velocidade, velocidade / 2)

func _on_RushArea_body_entered(body):
	if enemy_range.entity_aimed():
		velocidade = 300

func _on_RushArea_body_exited(body):
	velocidade = 100
