extends "res://Assets/Enimies/Perseguidores/Enemy_chaser_base.gd"

func chase():
	direction = global_position.direction_to(enemy_range.target.global_position)
	velocity = velocity.move_toward(direction * velocidade, velocidade / 2)

