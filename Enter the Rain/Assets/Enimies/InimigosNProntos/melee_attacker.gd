extends "res://Assets/Enimies/InimigosNProntos/Enemy_attack_base.gd"

func chase():
	rotation = (enemy_range.target.position - position).angle()
	direction = global_position.direction_to(enemy_range.target.global_position)
	velocity = velocity.move_toward(direction * velocidade, velocidade / 2)
